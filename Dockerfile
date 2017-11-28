FROM r-base:3.4.0

RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("sva")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("minfi")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("RnBeads")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("RnBeads.hg19")'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite(pkgs=c("minfiData","ChAMPdata","wateRmelon","FDb.InfiniumMethylation.hg19","ChAMP", "parallel","sandwich","lmtest","celltypes450","gap","ggplot2", "gdata","snpStats","GenomicRanges","DEXSeq","lumi","RnBeads.hg19","RnBeads","impute","illuminaio","wateRmelon","limma","methylumi","Biobase","IRanges","AnnotationDbi","MASS","IlluminaHumanMethylation450k.db","IlluminaHumanMethylation450kmanifest","CopyNumber450kData","DNAcopy"), dependencies=TRUE)'
RUN Rscript -e 'install.packages(c("Hmisc","devtools","MASS","lmtest","gplots","markdown","Cairo","knitr","doParallel","compareGroups","MatrixEQTL","plyr","dplyr","matrixStats","sandwich","ggplot2","glmnet","VennDiagram","parallel"), dependencies=TRUE)'

RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*
RUN curl 'https://www.cog-genomics.org/static/bin/plink171114/plink_linux_x86_64.zip'> plink.zip
RUN unzip plink.zip && rm plink.zip
RUN mv plink /usr/local/bin
