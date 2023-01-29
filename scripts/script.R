# Load data
library(readr)
data10 <- read_csv("C:/Workspace/github/ws_stats/data/output/dat_T10.csv")
data25 <- read_csv("C:/Workspace/github/ws_stats/data/output/dat_T25.csv")
data45 <- read_csv("C:/Workspace/github/ws_stats/data/output/dat_T45.csv")
data60 <- read_csv("C:/Workspace/github/ws_stats/data/output/dat_T60.csv")


# Combine columns
library(reshape2)
d10 <- melt(data10, id.vars="Cycles")
d25 <- melt(data25, id.vars="Cycles")
d45 <- melt(data45, id.vars="Cycles")
d60 <- melt(data60, id.vars="Cycles")


# define x,y
x10 <- d10$Cycles
x25 <- d25$Cycles
x45 <- d45$Cycles
x60 <- d60$Cycles
y10 <- d10$value
y25 <- d25$value
y45 <- d45$value
y60 <- d60$value

# Correlation
cor.test(x10, y10, alternative = 'less')
cor.test(x25, y25, alternative = 'less')
cor.test(x45, y45, alternative = 'less')
cor.test(x60, y60, alternative = 'less')

# Régression linéaire
modele10 = lm(y10~x10)
modele25 = lm(y25~x25)
modele45 = lm(y45~x45)
modele60 = lm(y60~x60)


# Plots
pdf("T10.pdf", width=8, height=4)
plot(x10, y10, pch = 20, cex=0.1,
     main = "Température 10 °C",
     xlab = "Cycles",
     ylab = "Capacité Ah (% de la valeur initiale)")
abline(modele10, col="red", lty=1, lwd=2)
dev.off()
pdf("T25.pdf", width=8, height=4)
plot(x25, y25, main = "Température 25 °C", pch = 20, cex=0.1,
     xlab = "Cycles", ylab = "Capacité Ah (% de la valeur initiale)")
abline(modele25, col="red", lty=1, lwd=2)
dev.off()
pdf("T45.pdf", width=8, height=4)
plot(x45, y45, main = "Température 45 °C", pch = 20, cex=0.1,
     xlab = "Cycles", ylab = "Capacité Ah (% de la valeur initiale)")
abline(modele45, col="red", lty=1, lwd=2)
dev.off()
pdf("T60.pdf", width=8, height=4)
plot(x60, y60, main = "Température 60 °C", pch = 20, cex=0.1,
     xlab = "Cycles", ylab = "Capacité Ah (% de la valeur initiale)")
abline(modele60, col="red", lty=1, lwd=2)
dev.off()

# Prediction à 80%
(0.8 - coef(modele10)[1])/coef(modele10)[2]
(0.8 - coef(modele25)[1])/coef(modele25)[2]
(0.8 - coef(modele45)[1])/coef(modele45)[2]
(0.8 - coef(modele60)[1])/coef(modele60)[2]

# Erreurs et boxplot
err10 = y10 - (coef(modele10)[2]*x10 + coef(modele10)[1])
err25 = y25 - (coef(modele25)[2]*x25 + coef(modele25)[1])
err45 = y45 - (coef(modele45)[2]*x45 + coef(modele45)[1])
err60 = y60 - (coef(modele60)[2]*x60 + coef(modele60)[1])

pdf("BoxPlot.pdf")
boxplot(err10, err25, err45, err60,
        names=c("10°C","25°C","45°C","60°C"),
        main = "Ecart du modèle linéaire",
        xlab = "Température",
        ylab = "Déviation")
dev.off()


# Kruskal - Wallis
x1 <- err10; x2 <- err25; x3 <- err45; x4 <- err60;
x <- c(x1, x2, x3, x4)
g <- factor(rep(1:4,
                c(length(x1), length(x2),
                  length(x3), length(x4))),
            labels = c("T10","T25","T45","T60"))
kruskal.test(x, g)

