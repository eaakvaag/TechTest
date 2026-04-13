#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#include "TFile.h"
#include "TTree.h"
#include "TError.h"
#include "Event.h"

void buildTree(const char *txt = "data/dimuon_91_stable_task1.txt",
               const char *out = "data/dimuon_91.root")
{

    std::ifstream fin(txt);
    if (!fin.is_open()) {
        Error("buildTree", "Cannot open %s", txt);
        return;
    }

    TFile *fout = TFile::Open(out, "RECREATE");
    if (!fout || fout->IsZombie()) {
        Error("buildTree", "Cannot create %s", out);
        return;
    }

    // Event object reused for each entry. ROOT stores a copy at Fill()
    Event evt; 
    Event *evtPtr = &evt; 
    TTree *tree = new TTree("events", "Muon events");

    tree->Branch("event", "Event", &evtPtr);

    std::string line; 
    bool haveEvent = false; 

    // Loop over input lines (format: "E:" for events, "P:" for particles)
    while(std::getline(fin, line)){
        if (line.size() < 2) continue;

        if (line[1] == 'E'){
            // New event: write previous event to tree
            if(haveEvent) tree->Fill();
            evt.clear(); 
            
            std::istringstream iss(line.substr(3)); 
            long eventId = 0; 
            iss >> eventId; 
            evt.setevt(eventId); 
            haveEvent = true;

        }else if (line[1] == 'P' && haveEvent) {
            // Particle record: idx, PDG id, px, py, pz, E, m
            std::istringstream iss(line.substr(3));
            int idx = 0; 
            int pdg = 0; 
            double px = 0, py = 0, pz = 0, ene = 0, mass = 0;
            iss >> idx >> pdg >> px >> py >> pz >> ene >> mass;
            
            std::vector<double> mom{px, py, pz};
            Particle part(pdg, mom, mass); 
            
            // Energy is already computed in the Particle constructor
            // Uncomment if keep the energy value from the input file instead
            // part.ee = ene; 

            evt.addParticle(part);

            // Debug: print event content
            // evt.print();
        }     
    }
    // Fill the last event
    if (haveEvent){
        tree->Fill();
        evt.clear();
    }

    Long64_t nEntries = tree->GetEntries();
    Info("buildTree", "Wrote %lld events to %s", nEntries, out);
   

    tree->Write();
    fout->Close();
    delete fout; 
    fin.close();

}

