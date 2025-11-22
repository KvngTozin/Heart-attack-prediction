library(shiny)
library(ggplot2)
library(plotly)
library(e1071)
library(caret)
library(shinythemes)
library(shinydashboard)

# ------------------------
# Sample dataset
# ------------------------
set.seed(123)
bmi_data <- data.frame(
  Age = sample(18:65, 10000, replace = TRUE),
  Height = sample(150:200, 10000, replace = TRUE),
  Weight = sample(50:120, 10000, replace = TRUE),
  Cholesterol = sample(70:250, 10000, replace = TRUE),
  Sleeping_Habits = sample(c("Good", "Poor"), 10000, replace = TRUE),
  Smoking = sample(c("Yes", "No"), 10000, replace = TRUE),
  Stress_Level = sample(c("Low", "Medium", "High"), 10000, replace = TRUE)
)

# BMI
bmi_data$BMI <- bmi_data$Weight / (bmi_data$Height/100)^2

# Heart attack logic
bmi_data$Heart_Attack <- ifelse(
  (bmi_data$Cholesterol > 200) |
    (bmi_data$Sleeping_Habits == "Poor") |
    (bmi_data$Weight > 100) |
    (bmi_data$Stress_Level == "High") |
    (bmi_data$Age > 55) |
    (bmi_data$Smoking == "Yes"),
  1,
  0
)

# Train/test split
trainIndex <- createDataPartition(bmi_data$Heart_Attack, p = 0.7, list = FALSE)
trainData <- bmi_data[trainIndex, ]
testData <- bmi_data[-trainIndex, ]

# Train Naive Bayes model
nb2_model <- naiveBayes(Heart_Attack ~ Age + Cholesterol + Smoking + Weight + Stress_Level + Sleeping_Habits + BMI,
                        data = trainData)

# ------------------------
# UI
# ------------------------
ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Health Assessment"),
  dashboardSidebar(
    sidebarMenu(menuItem("BMI and Heart Attack Risk", tabName = "bmi"))
  ),
  dashboardBody(
    tabItems(
      tabItem("bmi",
              fluidRow(
                box(
                  title = "BMI and Heart Attack Risk Calculation",
                  width = 6,
                  numericInput("age", "Age:", value = 30, min = 0),
                  numericInput("height", "Height (cm):", value = 170, min = 0),
                  numericInput("weight", "Weight (kg):", value = 70, min = 0),
                  numericInput("cholesterol", "Cholesterol Level:", value = 200, min = 70, max = 250),
                  selectInput("sleepingHabits", "Sleeping Habits:", choices = c("Good", "Poor")),
                  selectInput("smoking", "Do you smoke:", choices = c("Yes", "No")),
                  selectInput("stressLevel", "Stress Level:", choices = c("Low", "Medium", "High")),
                  actionButton("calcBMI", "Calculate BMI and Heart Attack Risk")
                ),
                box(
                  title = "Results",
                  width = 6,
                  h1(textOutput("bmiResult")),
                  br(),
                  h3("BMI Recommendations"),
                  textOutput("recommendation"),
                  br(),
                  plotlyOutput("bmiPlot"),
                  br(),
                  h3("Heart Attack Risk Prediction"),
                  textOutput("riskResult"),
                  textOutput("riskRecommendation")
                )
              )
      )
    )
  )
)

# ------------------------
# Server
# ------------------------
server <- function(input, output) {
  
  observeEvent(input$calcBMI, {
    # BMI calculation
    height_m <- input$height / 100
    bmi <- input$weight / (height_m^2)
    
    # Predict risk using Naive Bayes
    new_data <- data.frame(
      Age = input$age,
      Cholesterol = input$cholesterol,
      Smoking = input$smoking,
      Weight = input$weight,
      Stress_Level = input$stressLevel,
      Sleeping_Habits = input$sleepingHabits,
      BMI = bmi
    )
    
    predicted_risk <- predict(nb2_model, new_data)  # 0 or 1
    
    # BMI Result
    output$bmiResult <- renderText({ paste("Your BMI is:", round(bmi, 2)) })
    
    # BMI Recommendations
    output$recommendation <- renderText({
      if (bmi < 18.5) "Underweight. Increase calories and strength training."
      else if (bmi < 25) "Normal BMI. Maintain lifestyle."
      else if (bmi < 30) "Overweight. Exercise & balanced diet recommended."
      else "Obese. Focus on weight reduction and healthy lifestyle."
    })
    
    # Risk Result
    output$riskResult <- renderText({
      if (predicted_risk == 1) "You are at high risk for a heart attack." 
      else "You are at low risk for a heart attack."
    })
    
    # Risk Recommendations
    output$riskRecommendation <- renderText({
      recs <- c()
      if (input$cholesterol > 200) recs <- c(recs, "High cholesterol. Reduce saturated fats.")
      if (input$smoking == "Yes") recs <- c(recs, "Quit smoking to improve heart health.")
      if (bmi >= 30) recs <- c(recs, "Obese BMI. Focus on weight management.")
      else if (bmi >= 25) recs <- c(recs, "Overweight BMI. Diet & exercise important.")
      if (input$stressLevel == "High") recs <- c(recs, "Manage stress with mindfulness or exercise.")
      if (input$sleepingHabits == "Poor") recs <- c(recs, "Improve sleep quality (7-9 hours).")
      if (input$age > 55) recs <- c(recs, "Regular check-ups recommended for age > 55.")
      paste(recs, collapse = " ")
    })
    
    # BMI Plot
    output$bmiPlot <- renderPlotly({
      plot_ly(
        x = c("Underweight", "Normal", "Overweight", "Obese"),
        y = c(18.5, 24.9, 29.9, 34.9),
        type = 'bar',
        marker = list(color = c('lightblue', 'lightgreen', 'orange', 'red'))
      ) %>% layout(title = "BMI Category Breakdown",
                   xaxis = list(title = "Category"),
                   yaxis = list(title = "BMI Range"))
    })
    
  })
}

# ------------------------
# Run App
# ------------------------
shinyApp(ui = ui, server = server)

# ------------------------
# Evaluate model accuracy offline
# ------------------------
predicted <- predict(nb2_model, testData)
confusion <- confusionMatrix(as.factor(predicted), as.factor(testData$Heart_Attack))
accuracy <- confusion$overall['Accuracy']
print(paste("Model Accuracy:", round(accuracy * 100, 2), "%"))
