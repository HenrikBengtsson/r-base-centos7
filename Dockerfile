## Source: https://github.com/HenrikBengtsson/r-base-centos7
## Copyright: Henrik Bengtsson (2017)
## License: GPL (>= 2.1) [https://www.gnu.org/licenses/gpl.html]

FROM centos:centos7

MAINTAINER Henrik Bengtsson "henrikb@braju.com"

## Requirements during R configure
RUN yum install -y readline-devel           ## --with-readline=yes
RUN yum install -y gcc-c++
RUN yum install -y gcc-gfortran
RUN yum install -y zlib-devel
RUN yum install -y bzip2-devel
RUN yum install -y xz-devel                 ## liblzma
RUN yum install -y pcre-devel
RUN yum install -y curl-devel

RUN yum install -y libpng-devel             ## (optional) capabilities: png
RUN yum install -y libjpeg-devel            ## (optional) capabilities: jpeg
RUN yum install -y libtiff-devel            ## (optional) capabilities: tiff
RUN yum install -y libX11-devel libXt-devel ## (optional) capabilities: X11
RUN yum install -y cairo pango-devel        ## (optional) capabilities: cairo

RUN yum install -y libicu-devel             ## (optional) capabilities: ICU

RUN yum install -y texinfo                  ## (optional) for building HTML docs
RUN yum install -y texlive-latex-bin-bin    ## (optional) pdflatex

## Requirements during R make
RUN yum install -y make

## Requirements during R make --with-recommended-packages
RUN yum install -y java

## Requirements during R runtime
RUN yum install -y which                    ## R needs it for Sys.which()

## Requirements during R CMD check
RUN yum install -y qpdf
RUN yum install -y valgrind                 ## R CMD check --use-valgrind

## Requirements for Java                    ## R CMD javareconf below
RUN yum install -y java-1.8.0-openjdk-*

## Version of R to build and install
ENV R_VERSION=3.3.3

## Build and install R from source
RUN cd /tmp; curl -O https://cloud.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz
RUN cd /tmp; tar -zxf R-${R_VERSION}.tar.gz

RUN cd /tmp/R-${R_VERSION}; ./configure --with-readline=yes --enable-memory-profiling

RUN cd /tmp/R-${R_VERSION}; make
RUN cd /tmp/R-${R_VERSION}; make install

RUN R CMD javareconf

## R runtime properties
RUN mkdir /usr/local/lib64/R/site-library   ## Where to install packages

RUN echo "R_BIOC_VERSION=3.4" >> .Renviron
RUN echo 'options(repos = c(CRAN="https://cloud.r-project.org", BioCsoft="https://bioconductor.org/packages/3.4/bioc", BioCann="https://bioconductor.org/packages/3.4/data/annotation", BioCexp="https://bioconductor.org/packages/3.4/data/experiment", BioCextra="https://bioconductor.org/packages/3.4/extra"))' >> .Rprofile

