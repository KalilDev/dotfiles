#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>

int main(int argc, char **argv)
{
   int min = 0;
   int max = 100;
   if (argc >= 2)
   {
      try
      {
         min = std::stoi(argv[1]);
      }
      catch (...)
      {
         std::cerr << "Could not parse arg1: " << argv[1] << "\n";
      }
   }
   if (argc >= 3)
   {
      try
      {
         max = std::stoi(argv[2]);
      }
      catch (...)
      {
         std::cerr << "Could not parse arg1: " << argv[2] << "\n";
      }
   }
   std::string tp;
   while (std::getline(std::cin, tp))
   {
      try
      {
         // Convert the input to string
         int converted = std::stoi(tp);
         int clamped = converted > max ? max : converted < min ? min : converted;
         std::cout << clamped << "\n"; // Clamp the value
      }
      catch (...)
      {
         std::cerr << "Could not clamp val: " << tp << "\n";
      }
   }
}
