#' Match allelecounts with Allelic labels (MaC)
#' 
#' Function to match the allelic labels with the nucleotide counts obtained by alleleCounter at a given single nucleotide locus
#' This function will calculate the depth and variant/B-allele allele frequency (vaf/baf) for SNV/SNP
#' It requires the accompanying alleles file for the loci file used in alleleCounter which has four columns for
#' chromosome, position, reference nucleotide and alternative nucleotide of SNV/SNP and is assumed to have a header for these columns
#' @param samplename The sample name used in allelecounting - samplename is usually the the BAM ID (e.g. you'll have samplename.bam)
#' @param allelecount.prefix The character string that may have been assigned to the alleleCounter output file preceding the samplename (Default=NULL)
#' @param allelecount.suffix The character string that may have been assigned to the alleleCounter output file following the samplename (Default="_ac.txt")
#' @param allelesfile.prefix The character string that may have been assigned to the alleles file (cotaining ref and alt nucleotides of SNV/SNP) output file preceding the samplename (Default=NULL)
#' @param allelesfile.suffix The character string that may have been assigned to the alleles file (cotaining ref and alt nucleotides of SNV/SNP) output file following the samplename (Default="_alleles.txt")
#' @param output.suffix The character string to be added following the samplename to the output file name (Default="_mac.txt")
#' @param remove.na Should the variants with an NA vaf be removed i.e. SNV/SNP with depth=0? (Default=TRUE, use FALSE if output is required at same length as alleleCounter output)

MaC=function(samplename,allelecount.prefix,allelecount.suffix,allelesfile.prefix,allelesfile.suffix,output.suffix,remove.na=TRUE){
  ac=read.table(paste0(allelecount.prefix,samplename,allelecount.suffix),stringsAsFactors=F)
  print(paste("No. of variants with counts =",nrow(ac)))
  al=read.table(paste0(allelesfile.prefix,samplename,allelesfile.suffix),header=T,stringsAsFactors=F)
  colnames(al)=c("chr","pos","ref","alt")
  if (nrow(al[which(al$ref=="-" | al$alt=="-"),])>0){
    stop("Indels (insertion/deletion variants) detected in the alleles file - MaC only works for single nucleotide substitutions (i.e. SNV/SNP)")
  }
  al$ref[al$ref=="A"]=1
  al$ref[al$ref=="C"]=2
  al$ref[al$ref=="G"]=3
  al$ref[al$ref=="T"]=4
  al$alt[al$alt=="A"]=1
  al$alt[al$alt=="C"]=2
  al$alt[al$alt=="G"]=3
  al$alt[al$alt=="T"]=4
  ref=as.numeric(al$ref)
  ref_df=data.frame(pos=1:nrow(al),ref=ref+2)
  REF=ac[cbind(ref_df$pos,ref_df$ref)]
  alt=as.numeric(al$alt)
  alt_df=data.frame(pos=1:nrow(al),alt=alt+2)
  ALT=ac[cbind(alt_df$pos,alt_df$alt)]
  mac=data.frame(chr=al$chr,pos=al$pos,ref=as.numeric(REF),alt=as.numeric(ALT))
  mac$depth=mac$ref+mac$alt
  mac$vaf=mac$alt/mac$depth
  if (remove.na){
  mac=mac[which(!is.na(mac$vaf)),]
  print(paste("No. of variants retained after removing vaf==NA is",nrow(mac)))
  }
  write.table(mac,paste0(samplename,output.suffix),col.names=T,row.names=F,quote=F,sep="\t")
}
