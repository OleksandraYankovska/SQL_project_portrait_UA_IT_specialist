# SQL_project_portrait_of_UA_IT_specialist
SQL and Tableau Data Analysis | Gender portrait of Ukrainian IT specialists 2022



## [Click to view Tableau visualization of this project](https://public.tableau.com/app/profile/oleksandra2847/viz/GenderportraitofUkrainianITspecialists2022/Agemaritalstatuschildren)

The Tableau project contains 3 dashboards: Intro; Age, marital status, children; Map


⬆️ 
This data was collected by the team [DOU.UA](https://dou.ua) . 
This resource is very popular in Ukraine. It provides statistics, shows current vacancies and publishes useful articles related to the life of an IT specialist.
This dataset was taken from the public repository [https://github.com/devua/csv/tree/master/portrait ](https://github.com/devua/csv/tree/master/portrait)

After downloading the CSV dataset I used Excel to split data into multiple datasets.
The above datasets in .xlsx I converted to .json to import them into MySQL Workbench.

To build a Conceptual Model I used Entity relationship diagram
The names of the columns from the original data set I replaced with the relevant names in English to simplify the SQL Script. 
  
  
  ### The main questions we had:
  
  1.1 Total number of IT specialists by gender
  1.2 Total number by position and by gender 
  1.3 Total number by level and by gender
  
  2.1 IT specialists by age; the oldest and the youngest person by gender
  2.2 Marital status of IT specialists by gender
  2.2.1 Children of IT specialists
  2.3 Total number of persons staying in Ukraine and the number of people who are abroad, by gender, at the time of the survey
  2.4 Total number of persons staying in Ukraine by region
  2.5 10 countries to which Ukrainian IT specialists moved the most because of the war, by gender
  2.6 Plans to come back to Ukraine / plans to move from Ukraine by gender
  
  3.1 Education level by gender
  3.2 Knowledge of English by gender and by position; 
  
  4.1 The connection between knowledge of English and the level of satisfaction with salary;
  4.2 The connection between hours of work per week and the level of satisfaction with salary;
	
  5. Emotions by gender at the time of the survey
  
  
 So for this goal in my project I will not use all the data from the original data set but the following: 
  1) Ваша стать; Ваш вік; Ваш сімейний стан; Чи є у вас діти?;
  2) Стовпець1; Де живуть зараз - області; Де живуть зараз - країни; Чи переїжджали ви через початок війни?; Ви зараз живете…;Що ви думаєте про еміграцію з України?; В який регіон України ви переїхали через війну?; Чи плануєте ви повернутися?; Де ви зараз працюєте?; Чи плануєте ви повернутися?2;
  3) Оберіть вашу посаду; Ваш тайтл; Загальний стаж роботи в ІТ;
  4) Яка у вас освіта?; Знання англійської мови; Чи приділяєте час самонавчанню?; 
  5) Чи задоволені ви зарплатою?; Чи змінилася ваша зарплата через початок війни?;Чи маєте інші джерела доходу, окрім зарплати?; Яке ваше фінансове становище?; Багато ІТ-спеціалістів зараз підтримують фінансово українську армію та волонтерів. Чи можете ви оцінити, який % ваших щомісячних доходів іде на такі ініціативи?;
  6) В якій сфері проєкт, в якому ви зараз працюєте?; Тип компанії; Скільки годин на тиждень працюєте?; Як змінилась ваша продуктивність після початку повномасштабної війни?; Основна мова програмування;
  7) Ви працюєте зараз в ІТ?; Work status; Які зміни відбулися у вашій роботі з початком повномасштабної війни в Україні?; Які почуття ви найчастіше відчували протягом останнього тижня?
  
