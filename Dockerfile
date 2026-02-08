FROM rocker/rstudio:4.4.2

# 1. Switch to root for installation
USER root

# 2. Set a working directory (standard practice)
WORKDIR /home/rstudio/project

# 3. Copy only necessary renv files
# Note: Ensure these files exist in your GitHub repo!
COPY renv.lock .
COPY renv/activate.R renv/
COPY .Rprofile .

# 4. Install renv and restore
# We use --vanilla to ensure a clean R session
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"
RUN Rscript -e "renv::restore()"

# 5. Copy the rest of your scripts (like cowsay_test.R)
COPY . .

# 6. Fix permissions so the 'rstudio' user owns the project
RUN chown -R rstudio:rstudio /home/rstudio/project

# 7. Switch back to rstudio user
USER rstudio
