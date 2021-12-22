# numToKmer -- > Transforma um Índice de matriz em seu Kmer correspondete. 
# Input : Indice, Tamanho do K
# Output : Kmer Específico Correspondente.
def numToKmer(id, k)
    num = id + 1
    arestaStrSize = k+k
    aresta = Array.new(arestaStrSize)
    column = 4
    for i in 0..arestaStrSize-1
        sequeSize = column / 4
        # Trazendo o num pra primeira sequencia
        if(num > column) 
            num = num % column
            if(num == 0)
                num = 4
            end
        end
        # Verificando em que parte da sequencia está o num.
        if(num <= sequeSize)
            aresta[i] = "A"
        elsif(num > sequeSize && num <= sequeSize * 2)
            aresta[i] = "T"
        elsif(num > sequeSize * 2 && num <= sequeSize * 3)
            aresta[i] = "C"
        elsif(num > sequeSize * 3 && num <= column)
            aresta[i] = "G"
        end
        column = column * 4
        num = id + 1
    end
    str = ""
    aresta.each do |x|
        str.concat(x)
    end
    #puts "NumToAresta ===== ID = #{id} KMER = #{str}"
    str
end

# kmerToNum -- > Transformar Kmer em índice de Matriz.
# Input: Kmer, Tamanho do K
# Output : ID correspondente ao Kmer específico.
def kmerToNum(aresta, k)
    range = [0, (4**(k+k))]
    arestaArray = aresta.split(//)
    
    for i in (arestaArray.length-1).downto(0)
        #puts "--------------- i = #{i} ---------------"
        column = 4**i
        #puts "Column [#{column}]"
        if(arestaArray[i] == "A")
            max = (column * 1) - 1
            min = (column * 1) - column
        elsif(arestaArray[i] == "T")
            max = (column * 2) - 1
            min = (column * 2) - column
        elsif(arestaArray[i] == "C")
            max = (column * 3) - 1
            min = (column * 3) - column
        elsif(arestaArray[i] == "G")
            max = (column * 4) - 1
            min = (column * 4) - column
        end
        range[0] = range[0] + min
        if(i == arestaArray.length-1) # Primeira iteração
            range[1] = max
        else # demais iterações
            range[1] = range[0] + (min - max)
        end
        #puts "Min [#{min}] .. Max [#{max}]"
        #puts "Range[0] = #{range[0]} .. Range[1] = #{range[1]}"
    end
    #puts "kmerToNum ===== ID = #{range[0]} KMER = #{aresta}"
    if(range[0] == range[1])
        range[0]
    else
        "kmerToNum Error!"
    end
end