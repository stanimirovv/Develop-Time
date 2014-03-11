/*A Set Class made to work with points in the plane
it contains the basic set functions - union; intersection; subtraction
and parcial implementation of the symmetric difference.
Everything was made in less than 30 minutes.
*/
#include <iostream>
#include <vector>
#include <cmath>
 
using namespace std;
 
struct point{
        int x;
        int y;
};
 
class Set{
        private:
                vector<point> data;
        public:
                Set(){data;}
                int size() { return data.size();}
                point get_ele(int i){ return data[i];} // --------> Rather unneeded    
                void incr(point tmp)
                {
                        for(int i = 0; i < data.size(); i++)
                        {
                                if(tmp.x == data[i].x && tmp.y == data[i].y)
                                {
                                        return;
                                }
                        }
                        data.push_back(tmp);           
                }
        friend Set uni(Set a, Set b); // union
        friend Set inter(Set a, Set b); // intersection
        friend Set sub(Set a, Set b); // subtraction
        friend Set sym_diff(Set a, Set b); //symmetric difference
};
 
Set uni(Set a, Set b)
{
        Set ret;
        for(int i = 0; i < a.size(); i++)
        {
                //ret.incr(a.get_ele(i));
                ret.incr(a.data[i]);
        }
 
        for(int i = 0; i < b.size(); i++)
        {
                ret.incr(b.get_ele(i));
        }
        return ret;
}
 
Set inter(Set a, Set b)
{
        Set ret;
        for(int i = 0; i < a.size(); i++)
        {
                for(int j = 0; j < b.size(); j++)
                {
                        if(a.data[i].x == b.data[j].x && a.data[i].y == b.data[j].y)
                        {
                                ret.incr(a.data[i]);
                        }
                }
        }
        return ret;
}
 
Set sub(Set a, Set b)
{
        Set ret;
        for(int i = 0; i < a.size(); i++)
        {
                int sentinel = 0;
                for(int j = 0; j < b.size(); j++)
                {
                        if(a.data[i].x == b.data[j].x && a.data[i].y == b.data[j].y)
                        {
                                sentinel = -1;
                        }
                }
                if(sentinel == 0)
                        ret.incr(a.data[i]);   
        }
 
        return ret;
}
 
Set full_set(int boundry)
{
        Set ret;
        for(int i = 0; i < boundry; i++)
        {
                for(int j = 0; j < boundry; j++)
                {
                        point tmp;
                        tmp.x = i;
                        tmp.y = j;                     
                        ret.incr(tmp);
                }
        }
        return ret;
}
 
Set sym_diff(Set a, Set b)
{
        Set ret;       
        // get the full set
        // get the intersection of a and b
        // get the difference of full set and intersection (of a and b)
        return ret;
}
 
int main()
{
//Create different tests
        point tt1;
        tt1.x = 2;
        tt1.y = 3;
       
        point tt2;
        tt2.x = 3;
        tt2.y = 2;
 
        point tt3;
        tt3.x = 1;
        tt3.y = 1;
       
        Set a;
        a.incr(tt1);
        a.incr(tt2);
       
        Set b; 
        b.incr(tt2);
        b.incr(tt1);
 
        Set c = inter(a, b);
        cout << "Size INTER set c is    " << c.size() << endl;
       
        return 0;
}