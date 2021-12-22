## Constantes
inarqname = ARGV
k = 0
d = 0
kmer = String.new
genome = String.new
kmersList = Array.new
firstIteration = true

# Resgatando valor de K-mer, Distancia entre K-mers e Genoma.
DNAstring = File.open(inarqname[0]).each do |x|
    if(firstIteration)
        aux = x.split(/d/)
        k = /[\d]+/.match(aux[0])
        k = k[0].to_i
        d = /[\d]+/.match(aux[1])
        d = d[0].to_i
        firstIteration = false
    end
    genome.concat(x)
end

# Tratando Genoma, removendo partes inúteis.
genome = genome.upcase.split(//)
genome = genome.select {|x| x =~ /[ATCG]/}

# Montando lista de K-mers
for i in 0..genome.length-1
    if(i+k+k+d-1 >= genome.length)
        break
    end
    for j in 0..k-1 
        kmer = kmer.concat(genome[i+j])
    end
    kmer.concat("|")
    for j in 0..k-1
        kmer.concat(genome[i+k+d+j])
    end
    kmersList.push(kmer)
    kmer = ""
end
kmersList.sort!

# Criando Arquivo de Kmers e Salvando-os.
outarqname = "k#{k}d#{d}mer.txt"
File.open(outarqname, "w+") do |arq|
    arq.puts("k=#{k}d=#{d}")
    arq.print("[")
    kmersList.each do |x|
        if(x != kmersList.first)
            arq.print(" ")
        end
        arq.print(x)
        if(x != kmersList.last)
            arq.print(",")
        end
    end
    arq.print("]")
end

# Feedback de Execução Concluida.
puts "Archive \"#{outarqname}\" Created"
puts "Done!"