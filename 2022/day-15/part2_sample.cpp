#include <iostream>
#include <tuple>
#include <array>

std::array<std::tuple<int,int,int>, 14> sensors{
  std::make_tuple(2, 18, 7),  
{9, 16, 1},  
{13, 2, 3},  
{12, 14, 4}, 
{10, 20, 4}, 
{14, 17, 5}, 
{8, 7, 9},   
{2, 0, 10},  
{0, 11, 3},  
{20, 14, 8}, 
{17, 20, 6}, 
{16, 7, 5},  
{14, 3, 1},  
{20, 1, 7},  
};

constexpr auto manhattan_distance(int x1, int y1, int x2, int y2){
  return abs(x1 - x2) + abs(y1 - y2);
}

int main(){
  for(auto x=0; x<=20; ++x){
    std::cout << "row " << x << std::endl;
    for(auto y=0; y<=20; ++y){
      if (not std::any_of(std::begin(sensors), std::end(sensors), [&](auto sensor){ 
        auto [sx,sy, distance] = sensor;
//        std::cout << manhattan_distance(x,y,sx,sy) << std::endl;
        return manhattan_distance(x,y,sx,sy) <= distance; 
      })){
        std::cout << "found bad beacon at "<< x << "," << y << std::endl;
        exit(0);
      }
    }
  }
  std::cout << "done" << std::endl;
}
