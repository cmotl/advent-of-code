#include <iostream>
#include <tuple>
#include <array>

constexpr std::array<std::tuple<int,int,int>, 27> sensors{
  std::make_tuple(2288642, 2282562, 717544), 
{2215505, 2975419, 748134}, 
{275497, 3166843, 925344},  
{1189444, 2115305, 548911}, 
{172215, 2327851, 601896},  
{3953907, 1957660, 1094699},
{685737, 2465261, 1089766}, 
{1458348, 2739442, 591336}, 
{3742876, 2811554, 960112}, 
{437819, 638526, 1901123},  
{2537979, 1762726, 516163}, 
{1368739, 2222863, 262058}, 
{2743572, 3976937, 781451}, 
{2180640, 105414, 1037680}, 
{3845753, 474814, 1411237}, 
{2493694, 3828087, 382723}, 
{2786014, 3388077, 573273}, 
{3593418, 3761871, 1058809},
{856288, 3880566, 1544168}, 
{1757086, 2518373, 421799}, 
{2853518, 2939097, 503865}, 
{1682023, 1449902, 921879}, 
{3360575, 1739100, 673451}, 
{2904259, 1465606, 490629}, 
{3078500, 3564862, 457572}, 
{2835288, 1011055, 970525}, 
{2998762, 2414323, 596217}
};

inline constexpr auto manhattan_distance(const int x1, const int y1, const int x2, const int y2){
  return abs(x1 - x2) + abs(y1 - y2);
}

int main(){
  for(auto x=3000000; x<=4000000; ++x){
    std::cout << "row " << x << std::endl;
    for(auto y=0; y<=4000000; ++y){
      if (not std::any_of(std::cbegin(sensors), std::cend(sensors), [&](auto &sensor){ 
        const auto [sx,sy, distance] = sensor;
        return manhattan_distance(x,y,sx,sy) <= distance; 
      })){
        std::cout << "found bad beacon at "<< x << "," << y << std::endl;
        exit(0);
      }
    }
  }
  std::cout << "done" << std::endl;
}
