FROM debian:testing
## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
		fonts-texgyre \
	&& rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
	&& echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default


ENV R_BASE_VERSION 3.4.2

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
RUN apt-get update \
	&& apt-get install -t unstable -y --no-install-recommends \
		littler \
                r-cran-littler \
		r-base=${R_BASE_VERSION}* \
		r-base-dev=${R_BASE_VERSION}* \
		r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
        && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
	&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libcurl4-gnutls-dev libxml2-dev libmariadb-client-lgpl-dev && apt-get clean
RUN apt-get install -y libssl-dev && apt-get clean
RUN apt-get remove -y libcairo2-dev && apt-get clean
RUN apt-get update && apt-get install -y libgtk2.0-dev libcairo2-dev xvfb xauth xfonts-base ghostscript && apt-get clean
RUN apt-get update && apt-get install -y unzip git sshpass && apt-get clean
RUN apt-get update && apt-get install -y curl && apt-get clean

RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("sva")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("minfi")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("RnBeads")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("RnBeads.hg19")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite(pkgs=c("minfiData","ChAMPdata","wateRmelon","FDb.InfiniumMethylation.hg19","ChAMP", "parallel","sandwich","lmtest","celltypes450","gap","ggplot2", "gdata","snpStats","GenomicRanges","DEXSeq","lumi","RnBeads.hg19","RnBeads","impute","illuminaio","wateRmelon","limma","methylumi","Biobase","IRanges","AnnotationDbi","MASS","IlluminaHumanMethylation450k.db","IlluminaHumanMethylation450kmanifest","CopyNumber450kData","DNAcopy"), dependencies=TRUE)'
RUN Rscript -e 'install.packages(c("Hmisc","devtools","MASS","lmtest","gplots","markdown","Cairo","knitr","doParallel","compareGroups","MatrixEQTL","plyr","dplyr","matrixStats","sandwich","ggplot2","glmnet","VennDiagram","parallel"), dependencies=TRUE)'

RUN curl 'https://www.cog-genomics.org/static/bin/plink171103/plink_linux_x86_64.zip'> plink.zip
RUN unzip plink.zip && rm plink.zip
RUN mv plink /usr/local/bin

