FROM rocker/rstudio:4.1.3

LABEL org.label-schema.license="Apache 2.0" \
    org.label-schema.description="PatientLevelPrediction v3.0.0 environment based on Rocker/verse:3.5.1" \
    org.label-schema.vcs-url="https://github.com/ABMI/ohdsi-docker/patientlevelprediction" \
    org.label-schema.vendor="OHDSI Patient-Level Prediction Working Group" \
    maintainer="Seng Chan You <applegna@gmail.com>"

# install java develop kit and rJava
RUN apt-get update && \
    apt-get install -y default-jdk
RUN R CMD javareconf
RUN R -e "install.packages('rJava', dependencies = TRUE)"

# install devtools
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev \
    libgit2-dev \
    # install other    
    libfontconfig1-dev \    
    libcairo2-dev	


RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('data.table')"
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('shinycssloaders')"
RUN R -e "install.packages('shinydashboard')"
RUN R -e "install.packages('R.utils')"
RUN R -e "install.packages('rvg')"
RUN R -e "install.packages('renv')"
RUN R -e "install.packages('lubridate')"
RUN R -e "install.packages('reshape2')"
RUN R -e "install.packages('xgboost')"
RUN R -e "install.packages('diffr')"
RUN R -e "install.packages('meta')"
RUN R -e "install.packages('flextable')"
RUN R -e "install.packages('benchmarkme')"

# install PLP Packages 
RUN R -e 'devtools::install_github("OHDSI/OhdsiRTools",ref="v2.0.2")'
RUN R -e 'devtools::install_github("OHDSI/OhdsiSharing",ref="v0.2.2")'
RUN R -e 'devtools::install_github("OHDSI/DatabaseConnector",ref="v5.0.4")'
RUN R -e 'devtools::install_github("OHDSI/FeatureExtraction",ref="v3.2.0")'
RUN R -e 'devtools::install_github("OHDSI/PatientLevelPrediction",ref="v5.0.5")'
RUN R -e 'devtools::install_github("OHDSI/BigKnn",ref="v1.0.1")'
RUN R -e 'devtools::install_github("OHDSI/Andromeda",ref="v0.6.1")'
RUN R -e 'devtools::install_github("OHDSI/CohortDiagnostics",ref="v3.0.2")'
RUN R -e 'devtools::install_github("OHDSI/CirceR",ref="v1.1.1")'
RUN R -e 'devtools::install_github("OHDSI/ROhdsiWebApi",ref="v1.3.1")'

# install PLE Packages
RUN R -e 'devtools::install_github("OHDSI/CohortMethod",ref="v4.2.2")'
RUN R -e 'devtools::install_github("OHDSI/MethodEvaluation",ref="v2.2.0")'
RUN R -e 'devtools::install_github("OHDSI/EmpiricalCalibration",ref="v3.1.0")'

# create folders
RUN mkdir -p /home/rstudio/temp
RUN mkdir -p /home/rstudio/jdbc
RUN mkdir -p /home/rstudio/analysis
RUN mkdir -p /home/rstudio/result

# install JDBC driver
RUN R -e "DatabaseConnector::downloadJdbcDrivers(dbms = 'oracle',pathToDriver = '/home/rstudio/jdbc')"
RUN R -e "DatabaseConnector::downloadJdbcDrivers(dbms = 'postgresql',pathToDriver = '/home/rstudio/jdbc')"
RUN R -e "DatabaseConnector::downloadJdbcDrivers(dbms = 'sql server',pathToDriver = '/home/rstudio/jdbc')"

#### Graveyard ####
# ADD install_packages.r /home/rstudio/
# WORKDIR /home/rstudioRUN Rscript install_packages.r
# RUN git clone -b develop https://github.com/ohdsi/databaseConnector.git
# RUN chown -R rstudio:rstudio ./databaseConnector
