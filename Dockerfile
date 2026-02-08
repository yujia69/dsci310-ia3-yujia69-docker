FROM rocker/rstudio:4.4.2

RUN R -e "install.packages('cowsay')"