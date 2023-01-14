rule compare_genomes:
    message: "compare all input genomes using sourmash"
    shell: """
        sourmash sketch dna -p k=31 genomes/*.fna.gz --name-from-first

        sourmash compare GCF_000021665.1.sig \
            GCF_000017325.1.sig GCF_000020225.1.sig \
            -o compare.mat

        sourmash plot compare.mat
    """
