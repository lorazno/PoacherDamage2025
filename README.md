# PoacherDamage2025
Data from Testing the Limits: Functional Strengths and Weaknesses of Poacher (Agonidae) Armour

README made by Lorenzo Martinez on 2025-5-6

Data description:

1. Author Information: 
Corresponding Author and Information:

Name: Lorenzo Martinez

Affiliation: Rhodes College, Biology and Environmental Sciences Departments

Address: 2000 N Parkway, Memphis TN, 38112

Email: marle-26@rhodes.edu

2. Data collection information: 
Dates: June - August 2024

Location: Friday Harbor Laboratories, 620 University Rd, Friday Harbor, WA 98250

3. Research Funding:
Thank you to the Company of Biologists, American Association of Anatomists, and the Society of Integrative and Comparative Biology Division of Biomechanics for funding the supporting symposium. This research was supported by NSF Grant DBI-2419705 and the Seaver Institute for APS and DBI-2522148 to CMD; the Frederic H. and Kirstin C. Nichols Endowed Graduate Fellowship to MLV. The crab claw scan was provided by Glenna Clifton and the Murdock Natural Sciences Grant NS202222568. 

4. File information:

a. BathyagonusMTSData.csv:

Specimen = Specific specimen, CB = Crushed Bathyagonus; PB = Punctured Bathyagonus

Length = total specimen length

Location = Trial location on body, LA = Lateral Anterior, DA = Dorsal Anterior, LMA = Lateral Mid-Anterior, DTP = Dorsal Transition Point, LP = Lateral Posterior, DP = Dorsal Posterior

Height = measured "height" of specimen at trial location

maxLoad = maximum load recorded by MTS

extensionAtMadLoad = distance MTS extended to reach max load

workToMaxLoad = area under load/displacement curve until max load 

loadAtMaxExtension = load recorded by MTS at set maximum displacement

maxExtension = distance MTS displaced

workToMaxExtension = area under load/displacement curve until max extension

loadAtCrack = load recorded by MTS at point of fracture

ExtensionAtCrack = extension of MTS at point of fracture 

workToCrack = area under load/displacement curve until point of fracture

loadAtHoldStart = load recorded by MTS at start of pause (point of max extension)

loadAtHoldEnd = load recorded by MTS at end of pause (point of max extension)

b. CrackAngles.csv

Specimen = Specific specimen, CB = Crushed Bathyagonus; PB = Punctured Bathyagonus

IntendedDamage = trial location

ActualDamage = recorded damage seen in 3D slicer

Angle = fracture angle recorded in 3D slicer

PrimaryDirection = direction of fracture

method = trial type (crush or puncture)

DamageIntent = lateral/dorsal categories for trial type

Count = damage number for that location

Number = all set to 1 for graphing percentage out of total

c. crushedited.csv: first 16 columns same as BathyagonusMTSData.csv but filtered for crushed specimens

TrialType = all crushing (C)

Individual = Bathyagonus(number)

Orientation = Lateral or Dorsal for graphing

Position = location edited to generalize between posterior and anterior for graphing

Stress = Stress calculated using attached Rscript

Strain = Strain calculated using attached Rscript

d. AbrasionData.csv

method = trial type

specimen = specimen # (EB = ErodedBathyagonus, IB = ImpactedBathyagonus)

specimenLength = length of entire specimen

scanRes = microCT scan resolution

segHeight = height of segmentation at most anterior point

segLength = double the height

segSA = segment surface area

segVolume = segment volume

ratio = SA:V ratio

ratioL = SA:V ratio divided by specimen length

e. PoacherDamageScript.R = all Rscripts used to generate graphs, calculate statistics, and add categories. Each section is annotated and grouped by damage tests




