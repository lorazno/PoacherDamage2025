#load packages
library(readr)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(RColorBrewer)
library(lme4)

#load MTS data (puncture and crush) and add groupings for trial type, individual, orientation, and position-
#for analysis
MTSData <- read_csv("Directory/BathyagonusMTSData.csv")
MTSData <- mutate(MTSData,
                  trialType = substr(Specimen, 1, 1),
                  Individual = substr(Specimen, 2, nchar(Specimen)))
MTSData <- mutate(MTSData,
                  Orientation = substr(Location, 1, 1),
                  Position = substr(Location, 2, nchar(Specimen)))
MTSData <- MTSData %>%
  mutate(new_column = if_else(
    grepl("T$", Location),   # Check if category ends with 'T'
    "E",                     # Assign 'E' if true
    "F"                      # Assign 'F' if false
  ))
MTSData$Location = factor(MTSData$Location, 
                          levels = c("LA", "DA", "LMA", "DTP", "LP", "DP"))
MTSData$trialType = as.factor(MTSData$trialType)
MTSData$Individual = as.factor(MTSData$Individual)
MTSData$Orientation = as.factor(MTSData$Orientation)
MTSData$Position = as.factor(MTSData$Position)
#calculate stress and strain for quantification of crushed specimens based on height measurements
#treating the poacher body as circular in shape
MTSData$Stress = MTSData$maxLoad/(pi*((MTSData$Height)/2)^2)
MTSData$Strain = (MTSData$extensionAtMaxLoad-MTSData$Height)/MTSData$Height
#separate trial types for separate analysis
puncture = filter(MTSData, trialType == "P")
crush = filter(MTSData, trialType == "C")
write.csv(crush,"Directory/crushedited.csv")

#load corrected crush data with the outlier removed
crushedited <- read.csv("Directory/crushedited.csv")
crushedited$Location = factor(crushedited$Location, 
                              levels = c("LA", "DA", "LMA", "DTP", "LP", "DP"))

#Assign new puncture categories to analyze differences in orientation and between body regions
puncture <- puncture %>%
  mutate(new_column = if_else(
    grepl("D$", Orientation),   # Check if category ends with 'T'
    "Dorsal",                     # Assign 'Dorsal' if true
    "Lateral"                      # Assign 'Lateral' if false
  ))
puncture <- puncture %>%
  mutate(Region = if_else(
    grepl("A$", Location),   # Check if category ends with 'T'
    "Posterior",                     # Assign 'Posterior' if true
    "Anterior"                      # Assign 'Anterior' if false
  ))

#puncture graph with orientation, location, and region
ggplot(puncture, aes(x = Location, y = workToMaxLoad, fill = Region))+
  geom_boxplot(color = "white")+
  facet_wrap(~new_column, scales = "free_x", nrow = 1, strip.position = "bottom")+
  guides(fill = guide_legend(override.aes = list(size = 20)))+
  scale_fill_brewer(palette = "Paired", direction = -1)+
  theme(
    panel.background = element_rect(fill='transparent', color ="white", size = 1.5), #transparent panel bg
    plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
    panel.grid.major = element_blank(), #remove major gridlines
    panel.grid.minor = element_blank(), #remove minor gridlines
    legend.background = element_rect(fill='transparent'), #transparent legend bg
    legend.box.background = element_rect(fill='transparent', color = 'transparent'),
    text = element_text(size = 25, color = "white"), 
    axis.text = element_text(color = "white", size = 20), 
    strip.text = element_text(color = "white", size = 20), 
  )+
  ylab(bquote('Work (mJ)'))+
  theme(strip.background = element_blank())

#Assign new crush categories  to group by Orientation and Body region
crushedited <- crushedited %>%
  mutate(new_column = if_else(
    grepl("D$", Orientation),   # Check if category ends with 'T'
    "Dorsal",                     # Assign 'E' if true
    "Lateral"                      # Assign 'F' if false
  ))
crushedited <- crushedited %>%
  mutate(Region = if_else(
    grepl("P$", Location),   # Check if category ends with 'T'
    "Posterior",                     # Assign 'E' if true
    "Anterior"                      # Assign 'F' if false
  ))

#orientation, location, and region crush boxplot
ggplot(crushedited, aes(x = Location, y = Stress, fill = Region))+
  geom_boxplot(color = "white")+
  facet_wrap(~new_column, scales = "free_x", nrow = 1, strip.position = "bottom")+
  guides(fill = guide_legend(override.aes = list(size = 20)))+
  scale_fill_brewer(palette = "Paired")+
  theme(
    panel.background = element_rect(fill='transparent', color ="white", size = 1.5), #transparent panel bg
    plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
    panel.grid.major = element_blank(), #remove major gridlines
    panel.grid.minor = element_blank(), #remove minor gridlines
    legend.background = element_rect(fill='transparent'), #transparent legend bg
    legend.box.background = element_rect(fill='transparent', color = 'transparent'),
    text = element_text(size = 25, color = "white"), 
    axis.text = element_text(color = "white", size = 20), 
    strip.text = element_text(color = "white", size = 20), 
  )+
  ylab(bquote('Stress ' (N*mm^2)))+
  theme(strip.background = element_blank())

#puncture and crush stats
model1 = lm(maxLoad ~ Orientation + Location + trialType, MTSData)
anova(model1)
model2 = lm(workToMaxLoad ~ Orientation + Location, puncture)
anova(model2)
model3 = lm(Stress ~ Orientation + Location, crushedited)
anova(model3)

pairwise.t.test(crushedited$Stress, crushedited$new_column, 
                paired=FALSE, p.adjust.method="bonferroni")
pairwise.t.test(puncture$workToMaxLoad, puncture$new_column, 
                paired=FALSE, p.adjust.method="bonferroni")
t.test(Stress ~ new_column, crushedited)
t.test(workToMaxLoad ~ new_column, puncture)

#crush summary stats
StressStats = ddply(crushedited,.(Location),summarise,
                    n = length(maxExtension),
                    m = mean(maxExtension,na.rm=T),
                    std = sd(maxExtension,na.rm=T),
                    se = sd(maxExtension,na.rm=T)/sqrt(n))
show(StressStats)

#load abrasion data
AbrasionData <- read.csv("Directory/AbrasionData.csv")

#summary stats of method vs SA:V 
AbrasionSummary <- AbrasionData %>%
  group_by(method) %>%
  summarise(
    mean_ratio = mean(ratio, na.rm = TRUE),
    sd_ratio = sd(ratio, na.rm = TRUE),
    n = n(),
    se_ratio = sd_ratio / sqrt(n)
  )
#boxplot of surface area to volume ratio vs method 
ggplot(data = AbrasionData, aes(x=method, y=ratio, fill = method))+
  geom_boxplot(show.legend = FALSE, color = 'white')+
  theme_black(base_size=20)+
  scale_fill_brewer(palette = "Pastel1")+
  ylab(bquote('Surface Area:Volume'))+
  xlab(bquote('Method'))

t.test(ratio ~ method, AbrasionData)

#Load crack angle data sheet and separate by trial type for damage total calculations
CrackAngles<-read.csv("Directory/CrackAngles.csv")
puncturecount = filter(CrackAngles, method == "puncture")
crushcount = filter(CrackAngles, method == "crush")
CrackAngles$IntendedDamage <- factor(CrackAngles$IntendedDamage, levels = c("DA", "DTP", "DP", "LA", "LMA", "LP"))

#angle stats
model4 = lm(Angle ~ ActualDamage, CrackAngles)
anova(model4)
#summary stats
CrackSummary <- CrackAngles %>%
  group_by(method) %>%
  summarise(
    mean_angle = mean(Angle, na.rm = TRUE),
    sd_angle = sd(Angle, na.rm = TRUE),
    n = n(),
    se_angle = sd_angle / sqrt(n)
  )

#combined graph with all damage counts for each trial type
ggplot(CrackAngles, aes(fill=ActualDamage, y=Number, x=IntendedDamage)) + 
  geom_bar(position="fill", stat="identity", show.legend= TRUE)+
  facet_wrap(~method, scales = "free_x", nrow = 1, strip.position = "bottom")+
  scale_fill_brewer(palette = "pastels")+
  labs(
    x = "Location of Trial",
    y = "% of Observed Damages",
    legend = "Actual Damage")+
  theme(plot.title = element_text(hjust=0.5),
        strip.background = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.background = element_blank(),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        text = element_text(size = 15, color = "white"),
        axis.text = element_text(color = "white", size = 15),
        strip.text = element_text(color = "white", size = 15))+ 
  guides(fill=guide_legend(title="Observed Damage", override.aes = list(size = 9)))

#violin plot of angle distributions between methods
ggplot(CrackAngles, aes(x=method, y=Angle)) +
  geom_violin(fill = 'white', na.rm = TRUE)+
  geom_point(data = CrackSummary, aes(x = method, y = mean_angle), color = "red", size = 2, inherit.aes = FALSE) +
  geom_errorbar(data = CrackSummary, aes(x = method, ymin = mean_angle - se_angle, ymax = mean_angle + se_angle),
                width = 0.1, color = "red", inherit.aes = FALSE) +
  theme(
    panel.background = element_rect(fill = 'transparent', color = 'white'),
    plot.background = element_blank(),
    panel.grid = element_blank(),
    text = element_text(color = "white", size = 15),
    axis.text = element_text(color = "white")
  )+
  labs(
    x = "Damage Type",
    y = "Angle of Fracture (degrees)"
  )


