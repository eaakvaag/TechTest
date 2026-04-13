import uproot 
import matplotlib.pyplot as plt 
import awkward as ak 
import argparse

# Argument parser
parser = argparse.ArgumentParser(description="Plot sum of muon energies per event")
parser.add_argument("-i", "--input", default="data/dimuon_91.root",
                    help="Input ROOT file")
parser.add_argument("-o", "--output", default="plots/sum_muon_energy.png",
                    help="Output plot file")
args = parser.parse_args()

# Open the ROOT file and access the tree
tree = uproot.open(args.input)["events"]

#Read PDG ID and kinematic branches (only energy is needed) 
typ = tree["event/particles/particles.typ"].array()
energy = tree["event/particles/particles.ee"].array()
#mass = tree["event/particles/particles.mm"].array()
#momentum = tree["event/particles/particles.pp"].array()


# Select muons (PDG ID +/-13) and sum their energies event by event
muon_energies = energy[abs(typ)==13]
sum_muon_energies = ak.sum(muon_energies, axis=1)


# Plot the sum of muon energies per event
plt.figure(figsize=(6, 4))
plt.hist(sum_muon_energies, range=(80, 100), bins=40, histtype="step")

plt.xlabel("Sum muon energies [GeV]")
plt.ylabel("Events")
plt.grid(alpha=0.3)
plt.tight_layout()
plt.savefig(args.output)
print(f"Done! Plot saved to {args.output}")
#plt.show()