FROM rocker/rstudio:4.4.2

# Switch to root to install packages
USER root

#Copy renv files
COPY renv.lock renv.lock
COPY renv/ renv/

#Install renv inside container
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"

#Restore packages from lockfile
RUN Rscript -e "renv::restore()"

#Switch back to rstudio user for normal operation
USER rstudio