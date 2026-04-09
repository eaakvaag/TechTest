#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cmath>
#include <cstdio>
#include <sstream>

// A Event class
class Particle {
public:
    std::vector<double> pp;
    double ee;
    double mm;
    int    typ;

    Particle()
       : typ(0), ee(0), mm(0) {  pp[0] = 0; pp[1] = 0; pp[2] = 0; }
    Particle(int t, const std::vector<double> &p, double m)
      : typ(t), pp(p), mm(m) {  ee = sqrt(pp[0]*pp[0] + pp[1]*pp[1] + pp[2]*pp[2] + mm*mm); }
};

// A class that contains a list of Particle objects
class Event {
private:
    long evt;
    std::vector<Particle> particles;

public:
   Event() : evt(0) { }
    void clear() {
        particles.clear();
    }
   void setevt(long e) { evt=  e; }

    void addParticle(const Particle& p) {
        particles.push_back(p);
    }

    void print() const {
        std::cout << evt << ":" << std::endl;
        for (const auto& p : particles) {
           std::cout << "    " << p.typ << " : {" << p.pp[0] << "," << p.pp[1] <<"," << p.pp[2] << "} : " << p.ee << " : " << p.mm << std::endl;
        }
    }
};
