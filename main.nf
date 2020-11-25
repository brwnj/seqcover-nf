nextflow.enable.dsl=2

params.crams = false
params.reference = false
params.outdir = './results'
params.cpus = 4
params.percentile = 5
params.genes = false
params.opts = false

if(!params.crams) {
    exit 1, "--crams argument like '/path/to/*.cram' is required"
}
if(!params.reference) {
    exit 1, "--reference argument is required"
}
if(!params.genes) {
    exit 1, "--genes argument, e.g. 'PIGA,KCNQ2,ARX,DNM1', is required"
}

crams = channel.fromPath(params.crams)
crais = crams.map { it -> it + ("${it}".endsWith('.cram') ? '.crai' : '.bai') }


process mosdepth {
    container "brwnj/seqcover-nf:v0.1.0"
    publishDir "${params.outdir}/mosdepth"
    cpus params.cpus

    input:
    path(cram)
    path(crai)
    path(reference)

    output:
    path("*.d4"), emit: d4

    script:
    """
    mosdepth -f $reference -x -t ${task.cpus} --d4 ${cram.getSimpleName()} $cram
    """
}

process seqcover_background {
    container "brwnj/seqcover-nf:v0.1.0"
    publishDir params.outdir

    input:
    path(d4)
    path(reference)
    val(percentile)

    output:
    path("seqcover/*.d4"), emit: d4

    script:
    """
    seqcover generate-background -p 5 -f $reference -o seqcover/ $d4
    """
}

process seqcover_report {
    container "brwnj/seqcover-nf:v0.1.0"
    publishDir params.outdir

    input:
    path(d4)
    path(background)
    path(reference)
    val(genes)
    val(opts)

    output:
    path("*.html"), emit: html

    script:
    """
    seqcover report --background $background --genes $genes --fasta $reference $opts $d4
    """
}

workflow {
    mosdepth(crams, crais, params.reference)
    seqcover_background(mosdepth.output.d4.collect(), params.reference, params.percentile)
    seqcover_report(mosdepth.output.d4.collect(), seqcover_background.output.d4, params.reference, params.genes, params.opts)
}
