# Use Rocker RStudio base image with R version 4.4.2
FROM rocker/rstudio:4.4.2
# Switch to root for installing packages
USER root

# Copy renv files into container
COPY renv.lock renv.lock
COPY renv/ renv/

# Install renv inside container
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"

# Restore packages from lockfile
RUN Rscript -e "renv::restore()"

