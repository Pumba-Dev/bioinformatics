aminoDic = {"UUU" => "F",       "UCU" => "S",       "UAU" => "Y",        "UGU" => "C",
            "UUC" => "F",       "UCC" => "S",       "UAC" => "Y",        "UGC" => "C",
            "UUA" => "L",       "UCA" => "S",       "UAA" => "",        "UGA" => "",
            "UUG" => "L",       "UCG" => "S",       "UAG" => "",        "UGG" => "W",

            "CUU" => "L",       "CCU" => "P",       "CAU" => "H",        "CGU" => "R",
            "CUC" => "L",       "CCC" => "P",       "CAC" => "H",        "CGC" => "R",
            "CUA" => "L",       "CCA" => "P",       "CAA" => "Q",        "CGA" => "R",
            "CUG" => "L",       "CCG" => "P",       "CAG" => "Q",        "CGG" => "R",

            "AUU" => "I",       "ACU" => "T",       "AAU" => "N",        "AGU" => "S",
            "AUC" => "I",       "ACC" => "T",       "AAC" => "N",        "AGC" => "S",
            "AUA" => "I",       "ACA" => "T",       "AAA" => "K",        "AGA" => "R",
            "AUG" => "M",       "ACG" => "T",       "AAG" => "K",        "AGG" => "R",

            "GUU" => "V",       "GCU" => "A",       "GAU" => "D",        "GGU" => "G",
            "GUC" => "V",       "GCC" => "A",       "GAC" => "D",        "GGC" => "G",
            "GUA" => "V",       "GCA" => "A",       "GAA" => "E",        "GGA" => "G",
            "GUG" => "V",       "GCG" => "A",       "GAG" => "E",        "GGG" => "G"}

aminoTable = "                                 TABELA DE AMINOACIDOS \s 
                F = Fenilalanina        S = Serina          H = Histidina           N = Asparagina\s
                L = Leucina             P = Prolina         C = Cisteína            K = Lisina\s
                I = Isoleucina          T = Treonina        R = Arginina            D = Ácido Aspártico\s
                M = Metionina           A = Alanina         G = Glicina             E = Ácido Glutâmico\s
                V = Valina              Y = Tirosina        Q = Glutamina           W = Triptofano\s
                
                                           CADEIAS POLIPEPTIDICAS FORMADAS\s"
                

ribEnable = false ## Starting enable amino acid reading as false.
currentAminoAcid = "- "  ## Variable used to save processing amino acid.
File.open("AminoAcidChains.txt", "w") do |aminoArq| ## Open Archive To Write
    aminoArq.puts(aminoTable)
    File.open("RNAm.txt", "r").each do |line| ## Open Archive with RNAm Code
        line.gsub!(/\./, "") ## Remove undesirable points
        lineIndex = 0 ## Initialize index of line
        while(lineIndex < line.size) ## List each
            currentCodon = line[lineIndex] + line[lineIndex+1] + line[lineIndex+2] ## Catch codon   
            if(ribEnable == true)
                currentAminoAcid += aminoDic[currentCodon]
            end
            if(currentCodon == "AUG") ## Start Codon
                currentAminoAcid += aminoDic["AUG"]
                ribEnable = true
            elsif(currentCodon == "UAA" || currentCodon == "UAG" || currentCodon == "UGA") ## Stop Codons
                ribEnable = false
                aminoArq.puts currentAminoAcid
                currentAminoAcid = "- "
            end

            lineIndex += 3;
        end
    end
end

