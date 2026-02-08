FROM rocker/rstudio:4.4.2

# 1. Install system dependencies required for R packages (if any)
# cowsay is simple, but it's good practice to have these
USER root
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Set the working directory inside the container
WORKDIR /home/rstudio/project

# 3. Copy renv files first (better for Docker caching)
# We copy the lockfile, the profile, and the activation script
COPY renv.lock .
COPY .Rprofile .
COPY renv/activate.R renv/

# 4. Install renv and restore the environment
# We use --vanilla to prevent local R settings from interfering
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"
RUN Rscript -e "renv::restore(prompt = FALSE)"

# 5. Copy the rest of your project files
COPY . .

# 6. Fix permissions so the 'rstudio' user can work in this folder
RUN chown -R rstudio:rstudio /home/rstudio/project

# 7. Finalize setup
USER rstudio
