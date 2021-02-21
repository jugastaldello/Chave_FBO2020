library(shiny)
library(shinyjs)
library(shinyTree)
library(shinyWidgets)
library(shinythemes)

#################################
### Options
#################################

### Text

ui.bar.title = " "
ui.title.intro = div(HTML("Chave interativa para <em>Chamaecrista</em>"))
ui.title.panel1 = "Identificação"
ui.title.panel2 = "Comparação"
ui.title.panel3 = "Algumas imagens"
ui.title.characters = "Caracteres"
ui.instructions.characters = "Selecione os caracteres presentes no seu espécime. Conforme os caracteres são adicionados, espécies que não possuem tais características são eliminadas da lista. Na aba \"Comparação\" é possível visualizar uma tabela comparativa entre as espécies selecionadas.
* Inflorescência, flor axilar, muita atenção nesse caráter, poucas espécies têm essa condição. Se tiver dúvida opte por - racemos axilar com poucas flores."
ui.title.taxa = "Táxons"
ui.clean.button.label = "Limpa"


#################################
### Data
#################################

#setwd("/Users/ju_rando/Documents/Flora_do_Brasil/Chave_teste")

read.csv("Dat_matrix.csv", row.names = 1) -> mat
read.csv("Dat_characters.csv", stringsAsFactors = F, fileEncoding = "UTF-8") -> char.dat
data.frame(ID=c(1:ncol(mat)), Familys=colnames(mat)) -> fam


#################################
### Identificação - options
#################################

unique(char.dat$Check.box.id) -> ident.ids
vector("list", length=length(ident.ids)) -> cb.dat.id 
names(cb.dat.id) <- ident.ids
for (i in 1:length(ident.ids)) {
  ident.ids[i] -> id0
  char.dat[which(char.dat$Check.box.id == id0),] -> dat0
  dat0$Check.box.label[1] -> label0
  dat0$ID -> choices0
  dat0$Character -> names(choices0)
  list(id=id0, label=label0, choices=choices0) -> cb.dat.id[[i]]
}

#################################
### Comparação - options
#################################

fam$ID -> fam.choices
names(fam.choices) <- fam$Family
fam.choices[order(names(fam.choices))] -> fam.choices

### caracteres

unique(char.dat$Check.box.label) -> char.types.opts

#################################
### UI
#################################

ui <- fluidPage(
  navbarPage(ui.bar.title, theme = shinytheme("sandstone"), position="fixed-top",
             ### Intro
             tabPanel(ui.title.intro, fluidPage(includeMarkdown("intro.Rmd"))),
             
             ##################################    
             ### Identificação
             ##################################
                 tabPanel(ui.title.panel1, 
                          titlePanel(ui.title.panel1),
                          ##################################
                          ### Side Panel
                          sidebarPanel(
                            useShinyjs(),
                            titlePanel(ui.title.characters),
                            helpText(ui.instructions.characters),
                            helpText("\n", "\n"),
                            
                            ### Checkbox tree
                            
                            uiOutput("chars.tree"),
                            
                            helpText("\n", "\n"),
                            helpText(""),
                            
                            ### Buttons
                            actionButton("clean.button.1", ui.clean.button.label, icon=icon(name="thumbs-up", lib="glyphicon")),
                            helpText("\n", "\n"),
                                                       
                          ),
                          ##################################
                          ### Main Panel
                          mainPanel( 
                            titlePanel(ui.title.taxa),
                            helpText("\n", "\n"),
                            tabPanel("familias", tableOutput("familias.n")),
                            helpText("\n", "\n", "\n"),
                            tabPanel("familias", tableOutput("caracteres.n")),
                            helpText("\n", "\n", "\n"),
                            tabPanel("familias", tableOutput("familias.keep")),
                          )
                 ),
          ##################################
          ### Comparação
          ##################################
             tabPanel(ui.title.panel2, 
                      titlePanel(ui.title.panel2),
                      ##################################
                      ### Side Panel
                      sidebarPanel(
                        useShinyjs(),
                        titlePanel("Espécies"),
                        helpText("Selecione 1 ou mais espécies para comparar suas características."),
                        helpText("\n", "\n"),
                        # Famílias
                        dropdown(checkboxGroupInput(inputId = "familias.sel",
                                                    label = "Espécies:",
                                                    choices = fam.choices), 
                                                    label = "Espécies"),
                        helpText("\n", "\n"),
                        
                        # Characters
                        radioButtons(inputId = "chars.sel",
                                           label = "Caracteres:",
                                           choices = c(
                                             "Distintivos" = "distintivos",
                                             "Semelhantes" = "semelhantes",
                                             "Todos" = "todos"), selected="distintivos", inline=F
                                     ),
                        helpText("\n", "\n"),
                        
                        ### Checkbox characters 
                        checkboxGroupInput(inputId = "char.type",
                                           label = "Caracteres:",
                                           choices = char.types.opts),
                        
                        ### Clean
                        actionButton("clean.button.2", ui.clean.button.label, icon=icon(name="thumbs-up", lib="glyphicon")),
                        
                        helpText("\n", "\n"),
                        helpText("")
                      ),
                      ##################################
                      ### Main Panel
                      mainPanel( 
                        titlePanel("Tabela comparativa"),
                        helpText("\n", "\n"),
                        tabPanel("table.comp", tableOutput("familias.sel.n")),
                        helpText("\n", "\n", "\n"),
                        tabPanel("table.comp", tableOutput("chars.sel.n")),
                        helpText("\n", "\n", "\n"),
                        tabPanel("table.comp", tableOutput("familias.comp")),
                        helpText("\n", "\n", "\n")
                      )
             ), 
          
          ### About
          tabPanel(ui.title.panel3, fluidPage(includeMarkdown("about.Rmd")))
             
          
                 
  )
)


