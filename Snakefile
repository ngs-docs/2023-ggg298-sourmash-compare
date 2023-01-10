genome_urls = {
    'GCF_000021665.1': 'https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/021/665/GCF_000021665.1_ASM2166v1/GCF_000021665.1_ASM2166v1_genomic.fna.gz',
    'GCF_000017325.1': 'https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/017/325/GCF_000017325.1_ASM1732v1/GCF_000017325.1_ASM1732v1_genomic.fna.gz',
    'GCF_000020225.1': 'https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/020/225/GCF_000020225.1_ASM2022v1/GCF_000020225.1_ASM2022v1_genomic.fna.gz',
    }

rule all:
    input:
        expand("genomes/{accession}.fna.gz", accession=genome_urls),


rule download_genome:
    message: "download genome file for accession {wildcards.acc}"
    output:
        "genomes/{acc}.fna.gz",
    params:
        url = lambda w: genome_urls[w.acc]
    shell: """
        curl -JL {params.url} -o {output}
    """

rule prepare_genome:
    message: "build sourmash sketches for genome acc {wildcards.acc}"
    input:
        genome_file = "genomes/{acc}.fna.gz"
    output:
        sketch = "sketches/{acc}.sig"
    shell: """
        sourmash sketch dna -p k=31 {input.genome_file} -o {output.sketch} \
            --name-from-first
    """

rule compare_genomes:
    message: "compare all input genomes using sourmash"
    input:
        sketches = expand("sketches/{acc}.sig", acc=genome_urls)
    output:
        matrix = "compare.mat"
    shell: """
        sourmash compare {input.sketches} -o {output.matrix}
    """

rule plot_comparison:
    message: "create a visualization of the comparison"
    input:
        matrix = "compare.mat"
    output:
        "compare.mat.matrix.png"
    shell: """
        sourmash plot {input} --labels
    """
