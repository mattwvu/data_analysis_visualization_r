## Special Topic | Data Analysis and Visualization with R | Part IV ---------------------

# Matt Steele, Government Information Librarian, West Virginia University 

# R download and documentation - https://cran.r-project.org/
# RStudio download and documentation - https://rstudio.com
# This workshop was developed using the O'Reilly Platform Lesson video - R Programming for Statistics and Data Science  
# https://libwvu.on.worldcat.org/oclc/1062397089
# For more in-depth information and practical exercises on using R for Data science, I highly suggest using this resource


#Loading the Packages that we need ----------------------------------------

  install.packages("tidyverse")
  install.packages("foreign")
  install.packages("skimr")

  library(tidyverse)
  library(foreign)
  library(skimr)


#Working Directory ----------------------------------------------------------

  getwd()
  setwd()


## How plot ----------------------------------------------------------------

  # Basic steps:
  # set the data (main function)
  # choose a shape layer
  # map variables to aesthetics using aes() -> start with x and y in main function
  
  # Structure of Plots
  # Data - data you plotting
  # Aesthetics - what you map on x and y axis
  # Geometries - how your data will be represented visually

# First three are mandatory to create a plot. The following four are for flourish

  # Facets - discrete subplots that you graph can be split into 
  # Stats - statistical transformations you may choose to use
  # Coordinates - where data is plotted
  # Themes - non-data related information (fonts, colors)



# Step I | Getting that Data -----------------------------------------------

# Create an object that contains elements that your would like to plot
  
  bidenApproval <- read.csv("approval_topline_biden_2022.csv", stringsAsFactors = T)
  bidenApproval <- as_tibble(bidenApproval)
  bidenApproval 

  
  # Quick clean up
  
    str(bidenApproval)
  
  #Fix Date
  
    bidenApproval$modeldate <- as.Date(bidenApproval$modeldate, tryFormats = c("%m/%d/%Y"))
    bidenApproval
  
  #Fix name of president variable 
  
    bidenApproval <- mutate(bidenApproval, president = recode_factor(president, "Joe Biden" = "Joe Biden", 'Joseph R. Biden Jr.' = "Joe Biden" ))
    str(bidenApproval)
  
    skim(bidenApproval)

    
    
## Setting the Parameters with Aesthetics aes(x = ... , y = ...) --------------------------------------------------    

  bidenApproval.scatter <- ggplot(bidenApproval, aes(modeldate, approve_estimate))
  bidenApproval.scatter
  
  bidenApproval.scatter <- ggplot(bidenApproval, aes(x = modeldate, y = approve_estimate))
  bidenApproval.scatter
  
  
    
## Setting the type of plot with Geometries -------------------------------------------------------------
  
  bidenApproval.scatter + geom_point()
  
  #Color by factor levels
  
  bidenApproval.scatter + geom_point(aes(color = subgroup)) + 
    scale_color_manual(values=c("darkseagreen", "blueviolet", "coral")) +
    theme_minimal()
  
  
  #Save the factor color
  
  bidenApproval.scatter <- ggplot(bidenApproval, aes(x = modeldate, y = approve_estimate, color = subgroup, shape = subgroup))
  
  #Add a Reference Line
  
  bidenApproval.scatter + geom_point() + 
    geom_hline(yintercept = 50, size = 3, color = "grey") +
    theme_minimal()
  
  # The Order of the grammar of plotting is important
  
  bidenApproval.scatter + 
    geom_hline(yintercept = 50, size = 25, color = "grey", alpha = .25) + 
    geom_point() +
    theme_bw()
  

## Subsetting Factors with Facets ----------------------------------------------------------
  
    
  bidenApproval.scatter + 
    geom_hline(yintercept = 50, size = 25, color = "grey", alpha = .25) + 
    geom_point() + facet_grid(subgroup ~.) + 
    scale_color_manual(values=c("darkseagreen", "blueviolet", "coral")) +
    theme_minimal()
  

## Add a Statistical Transformation ----------------------------------------------------
  
  # Line to test for overplotting

  bidenApproval.scatter + geom_point() + facet_grid(subgroup ~.) + stat_smooth()
  
  # You can generally use geoms and stats interchangeably 
  
  bidenApproval.scatter + geom_point() + geom_smooth()
  
  # For instance you can use either to create a box plot stat_boxplot() == geom_boxplot()
  

# Theme() allows you to change the background of the plot -------------------------------
  
  bidenApproval.scatter + 
    geom_hline(yintercept = 50, size = 25, color = "grey", alpha = .25) + 
    geom_point() + 
    theme_update()
  
  
  bidenApproval.scatter + geom_hline(yintercept = 50, size = 25, color = "grey", alpha = .25) + 
    geom_point() + 
    theme_classic()
  

# Color and Fill allows you to color variables -------------------------------------------  
  
  bidenApproval.scatter <- ggplot(bidenApproval, aes(x = modeldate))
  
  bidenApproval.scatter + 
    geom_hline(yintercept = 50, size = 25, color = "grey", alpha = .25) + 
    geom_point (aes(y = approve_estimate), color = "darkseagreen") + 
    geom_point(aes(y = disapprove_estimate), color = "coral") + 
    theme_bw()
    

## Labs allow you to re-label x, y, title, and legend of the plot
  
  bidenApproval.scatter + 
    geom_hline(yintercept = 50, size = 25, color = "grey", alpha = .25) + 
    geom_point (aes(y = approve_estimate), color = "darkseagreen") + 
    geom_point (aes(y = disapprove_estimate), color = "coral") +  
    labs(y="Percent Approval", 
         x = "Date", 
         title = "Joe Biden Presidential Approval", 
         color = "category") +
    theme_classic()
  
  
  
  
## Histogram ----------------------------------------------------------------------------------------
  
  
  spssDemo <- read_csv("demo_20220309.csv")
  spssDemo <- as_tibble(spssDemo)
  summary(spssDemo)
  
  view(spssDemo)
 
 
  spssDemo.hist <- ggplot(data = spssDemo, aes(x = age))
  
  spssDemo.hist + 
    geom_histogram(binwidth = 5, color = "yellow", fill = "skyblue") + theme_classic()
  
  #Bins allow to group numeric values into groups based of percentages
  
    spssDemo.hist + 
      geom_histogram(binwidth = 10, color = "yellow", fill = "skyblue") + theme_classic()
  
  #Give in a Title
  
    spssDemo.hist + 
      geom_histogram(binwidth = 5, color = "yellow", fill = "skyblue", alpha = 0.5) + 
      labs(title = "Age Distribution of Participants") + 
      theme_classic()
  
  #Give the x and y axis some labels
  
    spssDemo.hist + 
      geom_histogram(binwidth = 5, color = "yellow", fill = "skyblue", alpha = 0.5) +
      labs(y = "Number of Participants", 
         x = "Age",
         title = " Age Distribution on the Titanic") +
      theme_classic()
 
  
## Bar graph ----------------------------------------------------------------------------------
  
  spssDemo_bar <- ggplot(spssDemo, aes(x = inccat,  fill = age_cat)) 
    #binds the variable Income Category and Marital Status
  
  spssDemo_bar + geom_bar()
 
   spssDemo_bar + geom_bar() + theme_light() +
    labs(y = "Count",
         x = "Income Category",
         title = "Income and Marital Status")
    # Subsets the graph by gender and education level
   
   
   
   spssDemo_bar + geom_bar() + theme_light() +
     labs(y = "Count",
          x = "Income Category",
          title = "Income and Age Group by Gender", 
          fill = "Age") + 
     facet_wrap(~gender)
  
    # Add another layer by subsetting the plot gender
   
   
# You can export graphs to image or pdf using the export button in the bottom right pane.
  
# You can create a publishing report which can be exported as a PDF or HTML using File > RMarkdown  