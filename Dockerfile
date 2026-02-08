# Base image specified in assignment
FROM rocker/rstudio:4.4.2

# 1. Switch to root to install system dependencies and R packages
USER root

# 2. Set the working directory
WORKDIR /home/rstudio/project

# 3. Copy renv files first for better layer caching
# Ensure renv.lock, .Rprofile, and the renv/ folder are in your GitHub repo
COPY renv.lock .
COPY .Rprofile .
COPY renv/activate.R renv/

# 4. Install renv and restore the environment
# We disable the sandbox and symlinks so packages are "baked" into the image
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"
RUN Rscript -e "options(renv.config.cache.enabled = FALSE); renv::restore(prompt = FALSE)"

# 5. Copy the rest of your project files (like your cowsay_test.R script)
COPY . .

# 6. Fix permissions so the 'rstudio' user can access the project
RUN chown -R rstudio:rstudio /home/rstudio/project

# 7. Switch back to rstudio user as required by assignment hints
USER rstudio
