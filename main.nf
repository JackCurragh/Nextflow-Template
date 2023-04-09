#!/usr/bin/env nextflow

/// Specify to use Nextflow DSL version 2
nextflow.enable.dsl=2

/// Import modules and subworkflows
include { quality_control } from './subworkflows/quality_control.nf'

// Log the parameters
log.info """\

=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
||                        INSERT PIPELINE NAME                             ||
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
||  Parameters                                                             ||
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
||  input_dir   : ${params.input_dir}                                      ||
||  outDir      : ${params.outDir}                                         ||
||  workDir     : ${workflow.workDir}                                      ||
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=

"""
// Help Message to prompt users to specify required parameters
def helpMessage() {
    log.info"""
  Usage:  nextflow run main.nf --input <path_to_fastq_dir> 

  Required Arguments:

  --input    Path to directory containing fastq files.

  Optional Arguments:

  --outDir	Path to output directory. 
	
""".stripIndent()
}

/// Define the main workflow
workflow main {
    /// Define the input channels
    fastq_ch = Channel.fromPath('$params.input_dir/*.fastq.gz')

    /// Run the subworkflow
    quality_control(fastq_ch)
}

workflow.onComplete {
    log.info "Pipeline completed at: ${new Date().format('dd-MM-yyyy HH:mm:ss')}"
}
