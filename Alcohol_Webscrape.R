#XML web data scraping in R example.
#The following code reads an XML data file obtained from data.gov.
#The data is read and then plotted, to show the  total amount of alcohol (in kiloliters) 
#exported from the U.S.A. to Canada for each month of 2016.

#Set the working directory.
setwd("C:\\Users\\310084562\\My Documents\\Webscraping_Alcohol")

#Open the XML, extra font, and ggplot2 libraries.
library(XML)
library(ggplot2)
library(extrafont)



#Load the extra fonts available in Windows.  Available Windows fonts
#were already imported using the font_import() command.
loadfonts(device="win")

#Parse the XML data file.
xml_alcohol <- xmlParse("Feed Grains Custom Query Results.xml")

#Get the rootNode of the xml file.
rootNode <- xmlRoot(xml_alcohol)

#Get the XML data values in each tag and put them into a matrix.
alcohol_data <- xmlSApply(rootNode, function(x) xmlSApply(x, xmlValue))

#Take the transpose of this matrix to put the tag ids as columns.
alcohol_data <- t(alcohol_data)

#Convert matrix to a data frame.
alcohol_data <- data.frame(alcohol_data,row.names = NULL)

#Change the name of the second column in the data frame to be "Month". 
colnames(alcohol_data)[2] <- "Month"

#Convert the month column to a factor and the Amount column to numeric.
#Make sure the months are in proper order from January to December.
alcohol_data$Month <- factor(alcohol_data$Month, month.abb, ordered=TRUE)

#Alcohol amounts converted to numeric and rounded to zero decimal places.
alcohol_data$Amount <- as.character(alcohol_data$Amount)
alcohol_data$Amount <- as.numeric(alcohol_data$Amount)
alcohol_data$Amount <- round(alcohol_data$Amount,0)


#Open up the png graphics device.  Set the width and height of the image.
png(file="AlcoholPlot.png", width = 1100, height = 600)


#Create a bar plot of the amount of booze shipped from the U.S.A.
#to Canada for each month of 2016.
booze_plot <- ggplot(alcohol_data, aes(Month,Amount))
booze_plot <- booze_plot + geom_bar(colour="black", fill = "#FF6666",  stat = "identity") +
  labs(x = "Month", y = "Alcohol Exported (kiloliters)", size = 4) + 
  labs(title = "Total Amount of Alcohol Exported from the U.S.A. to Canada in 2016") + 
  theme(text = element_text(size=20, family="Lucida Console"))
print(booze_plot)


#Turn off the graphics device.
dev.off()