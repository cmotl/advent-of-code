import re

sample_input = """ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"""
sample_input_lines = sample_input.split('\n')

def extract_fields(raw):
  fields = {}
  for f in raw.split(' '):
    k,v = f.split(':')
    fields[k] = v
  return fields


def extract_passports(input):
  fields = {}

  for x in input:
    if x == "":
      yield fields
      fields = {}
    else:
      fields.update(extract_fields(x))

  if len(fields) is not 0:
    yield fields

def contains_all_required_fields(passport):
  return 'byr' in passport and \
         'iyr' in passport and \
         'eyr' in passport and \
         'hgt' in passport and \
         'hcl' in passport and \
         'ecl' in passport and \
         'pid' in passport

def valid_birth_year(year):
  if not len(year) is 4:
    return False
  if not year.isnumeric():
    return False

  year = int(year)
  if year < 1920:
    return False
  if year > 2002:
    return False

  return True

def valid_issue_year(year):
  if not len(year) is 4:
    return False
  if not year.isnumeric():
    return False

  year = int(year)
  if year < 2010:
    return False
  if year > 2020:
    return False

  return True

def valid_expiration_year(year):
  if not len(year) is 4:
    return False
  if not year.isnumeric():
    return False

  year = int(year)
  if year < 2020:
    return False
  if year > 2030:
    return False

  return True

def valid_passport_id(id):
  if len(id) is not 9:
    return False
  if not id.isnumeric():
    return False

  return True

def valid_eye_color(color):
  valid_colors = ['amb','blu','brn','gry','grn','hzl','oth']
  return color in valid_colors

def valid_hair_color(color):
  a = re.search('#(?:[0-9a-f]{6})', color)
  return a is not None

def valid_height(height):
  m = re.match('^(^\d+)(cm|in)$', height)

  if not m:
    return False
 
  value, scale = int(m[1]), m[2]

  if scale == 'cm':
    return value >=150 and value <= 193
  elif scale == 'in':
    return value >= 59 and value <= 76

  return False

def valid_fields(passport):
  return valid_birth_year(passport['byr']) and \
         valid_issue_year(passport['iyr']) and \
         valid_expiration_year(passport['eyr']) and \
         valid_height(passport['hgt']) and \
         valid_hair_color(passport['hcl']) and \
         valid_eye_color(passport['ecl']) and \
         valid_passport_id(passport['pid'])

input = open("input.txt", "r").readlines()
raw_passport_data = map(lambda x: x.strip(), input)
passports = list(extract_passports(raw_passport_data))

def valid_passports(passports):
  return [x for x in passports if contains_all_required_fields(x)]
print(len(valid_passports(passports)))

def valid_passports_with_verification(passports):
  return [x for x in passports if contains_all_required_fields(x) and valid_fields(x)]
print(len(valid_passports_with_verification(passports)))

def test_extract_passports():
  assert(4 == len(list(extract_passports(sample_input_lines))))

def test_contains_all_required_fields():
  passport = {
    'byr':'1937',
    'iyr':'2017',
    'eyr':'2020',
    'hgt':'183cm',
    'hcl':'#fffffd',
    'ecl':'gry',
    'pid':'860033327'
  }
  assert(contains_all_required_fields(passport))

def test_valid_birth_year():
  assert(False == valid_birth_year('abc'))
  assert(False == valid_birth_year('abcde'))
  assert(False == valid_birth_year('abcd'))
  assert(False == valid_birth_year('1900'))
  assert(False == valid_birth_year('2100'))
  assert(True == valid_birth_year('1920'))
  assert(True == valid_birth_year('2002'))
  assert(True == valid_birth_year('1980'))

def test_valid_issue_year():
  assert(False == valid_issue_year('abc'))
  assert(False == valid_issue_year('abcde'))
  assert(False == valid_issue_year('abcd'))
  assert(False == valid_issue_year('1900'))
  assert(False == valid_issue_year('2100'))
  assert(True == valid_issue_year('2010'))
  assert(True == valid_issue_year('2020'))
  assert(True == valid_issue_year('2015'))

def test_valid_expiration_year():
  assert(False == valid_expiration_year('abc'))
  assert(False == valid_expiration_year('abcde'))
  assert(False == valid_expiration_year('abcd'))
  assert(False == valid_expiration_year('1900'))
  assert(False == valid_expiration_year('2100'))
  assert(True == valid_expiration_year('2020'))
  assert(True == valid_expiration_year('2030'))
  assert(True == valid_expiration_year('2025'))

def test_valid_passport_id():
  assert(False == valid_passport_id('aaaaaaaaa'))
  assert(False == valid_passport_id('00000000a'))
  assert(False == valid_passport_id('a00000000'))
  assert(True == valid_passport_id('000000000'))
  assert(True == valid_passport_id('999999999'))
  assert(True == valid_passport_id('123456789'))
  assert(False == valid_passport_id('12345678'))
  assert(False == valid_passport_id('1234567890'))

def test_valid_eye_color():
  assert(False == valid_eye_color('blue'))
  assert(True == valid_eye_color('amb'))
  assert(True == valid_eye_color('blu'))
  assert(True == valid_eye_color('brn'))
  assert(True == valid_eye_color('gry'))
  assert(True == valid_eye_color('grn'))
  assert(True == valid_eye_color('hzl'))
  assert(True == valid_eye_color('oth'))

def test_valid_hair_color():
  assert(False == valid_hair_color('blue'))
  assert(False == valid_hair_color('#00ff9A'))
  assert(True == valid_hair_color('#00ff9a'))

def test_valid_height():
  assert(False == valid_height('34ft'))
  assert(False == valid_height('149cm'))
  assert(False == valid_height('194cm'))
  assert(True == valid_height('150cm'))
  assert(True == valid_height('193cm'))
  assert(False == valid_height('58in'))
  assert(False == valid_height('77in'))
  assert(True == valid_height('59in'))
  assert(True == valid_height('76in'))

test_extract_passports()
test_contains_all_required_fields()
test_valid_birth_year()
test_valid_issue_year()
test_valid_expiration_year()
test_valid_passport_id()
test_valid_eye_color()
test_valid_hair_color()
test_valid_height()
