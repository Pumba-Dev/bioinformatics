# readArchive -- > Resgatando valor de distância(d) e salvando lista de Kmers em String
# Input : ---
# Outpuy : Array of K,d-mers
def readArchive() 
    k = ""
    d = ""
    kmerList = ""
    firstIteration = true
    File.open(ARGV[0]).each do |x|
        if(firstIteration)
            k = /[\d]+/.match(x)
            d = /[\d]+/.match(k.post_match)
            k = k[0].to_i
            d = d[0].to_i
            firstIteration = false
        else
            kmerList.concat(x)
        end
    end

    # Tratando lista de Kmers e colocando em Array.
    kmerList = kmerList.split(/',\s'/)
    kmerList[0].delete_prefix!("['")
    kmerList[kmerList.length-1].delete_suffix!("']")
    kmerList.push(k)
    kmerList.push(d)
    kmerList
end

# createHashID -- > Cria um ID único para cada K,D-mer existente na lista.
# Input: List of K,d-mers
# Output: Hash | Key = K,d-mer and Value = ID
def createHashID(kmerlist, k)
    dicTable = Hash.new
    count = 0
    for i in 0..kmerlist.length-1
        # Prefix
        prefix = ""
        for j in 0..(k-2)
            prefix.concat(kmerlist[i][j])
        end
        for j in (k+1)..(k+k-1)
            prefix.concat(kmerlist[i][j])
        end
        # Sufix
        sufix = ""
        for j in 1..(k-1)
            sufix.concat(kmerlist[i][j])
        end
        for j in (k+2)..(k+k)
            sufix.concat(kmerlist[i][j])
        end
        # Hash Fill
        if(!dicTable.include?(prefix))
            dicTable[prefix] = count
            count += 1
            #puts "Kmer = #{prefix} | Include? = #{dicTable.include?(prefix)} | ID #{count}"
        end

        if(!dicTable.include?(sufix))
            dicTable[sufix] = count
            count += 1
            #puts "Kmer = #{sufix} | Include? = #{dicTable.include?(sufix)} | ID #{count}"
        end
        
    end
    dicTable
end

# deBruijnFill -- > Preenche a matriz de adjacência com o prefixo apontando para seu correspondente sufixo
# Input: Empty Graph, Lista de K,d-mers, K value
# Output: DeBruijn Graph
def deBruijnFill(deBruijn, kmerlist, dicTable, k)
    for i in 0..kmerlist.length-1
        # Prefix
        prefix = ""
        for j in 0..(k-2)
            prefix.concat(kmerlist[i][j])
        end
        for j in (k+1)..(k+k-1)
            prefix.concat(kmerlist[i][j])
        end
        # Sufix
        sufix = ""
        for j in 1..(k-1)
            sufix.concat(kmerlist[i][j])
        end
        for j in (k+2)..(k+k)
            sufix.concat(kmerlist[i][j])
        end
        #puts "#{prefix} ---> #{sufix}"
        prefix = dicTable[prefix]
        sufix = dicTable[sufix]
        deBruijn[prefix][sufix] = deBruijn[prefix][sufix] + 1
        #puts "#{prefix} ---> #{sufix}"
    end
    deBruijn
end

# printGraph -- > Imprime a matriz do grafo.
# Input : Matriz de Adjacência
# Output : ---
def printGraph(deBruijn)
    for i in 0..deBruijn.length-1
        print deBruijn[i]
        puts ""
    end
end

# findOrphanNode -- > Seleciona o Nó que não tem Pai
# Input : Non-Eulerian Graph
# Output: ID of node without father.
def findOrphanNode(graph)
    for i in 0..graph.length-1
        sum = 0
        for j in 0..graph.length-1
            sum += graph[j][i]
        end
        if(sum == 0)
            node = i
            break
        end
    end
    node    
end

# findSterileNode -- > Seleciona o Nó que não tem filhos
# Input : Non-Eulerian Graph
# Output: ID of node without son.
def findSterileNode(graph)
    for i in 0..graph.length-1
        sum = 0
        for j in 0..graph.length-1
            sum += graph[i][j]
        end
        if(sum == 0)
            node = i
            break
        end
    end
    node  
end

# deBruijnToEuler -- > Transforma um grafo de De Bruijn em um Grafo Euleriano Conexo e Balanceado.
# Input : De Bruijn Graph
# Output: Euler Graph
def deBruijnToEuler(deBruijn, sterileNode, orphanNode)
    deBruijn[sterileNode][orphanNode] += 1
    eulerGraph = deBruijn
    eulerGraph
end

# FORMIGUINHA LEO

# Movie -- > Objeto que guarda um movimento no grafo
# Atributos: 
#   @SourceNode -> Nó origem do movimento
#   @DestinyNode -> Nó destino do movimento.
class Movie 
    attr_accessor :sourceNode, :destinyNode

    def initialize(sourceNode, destinyNode)
        @sourceNode = sourceNode
        @destinyNode = destinyNode
    end

    def to_s
        "#{sourceNode}-->#{destinyNode}"
    end
end

# findArrowNotVisited -- > Seleciona Nó com Arestas não visitadas.
# Input : EulerGraph
# Output : Node ID
def findArrowNotVisited(eulerGraph)
    aresta = 0
    for i in 0..eulerGraph.length-1
        for j in 0..eulerGraph.length-1
            if(eulerGraph[i][j] >= 1)
                aresta = i
                break;
            end
        end
    end
    aresta
end

# antLeo -- > Faz um percurso no grafo e retorna o caminho que foi feito.
# Input: graph, nó inicial, caminho
# Output: Array of Movie
def antLeo(graph, sourceNode, path, actualDeepLevel, nodeCount)
    if(actualDeepLevel > nodeCount)
        return -1
    end
    unless(path == -1)
        for i in 0..graph.length-1
            if(graph[sourceNode][i] > 0)
                path.push(Movie.new(sourceNode, i))
                graph[sourceNode][i] -= 1
                actualDeepLevel += 1
                path = antLeo(graph, i, path, actualDeepLevel, nodeCount)
            end
        end
    end
    path
end

# removeUsedPath -- > Remove as arestas de um ciclo em um grafo
# Input: Grafo, Path
# Output: Grafo withour Path Arestas
def removeUsedPath(graph, path)
    path.each do |x|
        graph[x.sourceNode][x.destinyNode] -= 1
    end
    graph
end

# Path Integer to String -- > Converte um caminho Path formado por inteiros para K,D-Mers
# Input: Path, Hash Num-->K,d-mer
# Output: Str Path
def pathIntToStr(path, invertDicTable)
    newPath = Array.new
    path.each do |x|
        newPath.push(Movie.new(invertDicTable[x.sourceNode], invertDicTable[x.destinyNode]))
    end
    newPath.pop
    newPath
end

# fixUnion -- > Transforma um Path formado por Prefixo --> Sufixo em um Path formado por K,D-mer -- > K,D-mer
# Input: Path
# Output: NewPath
def fixUnion(path)
    newPath = Array.new
    path.each do |x|
        txtSource = x.sourceNode.split(//)
        txtDestiny = x.destinyNode.split(//)
        source = ""
        for i in 0..((txtSource.length/2)-1)
            source.concat(txtSource[i])
        end
        source.concat(txtDestiny[((txtDestiny.length/2)-1)])
        destiny = ""
        for i in (txtSource.length/2)..(txtSource.length-1)
            destiny.concat(txtSource[i])
        end
        destiny.concat(txtDestiny.last)
        newPath.push(Movie.new(source, destiny))
        #puts Movie.new(source, destiny)
    end
    newPath
end

# createMatrizOfRemake -- > Criando Matriz de recriação, colocando cada Path em seu respectivo lugar na matriz.
# Input: Path, Value of K and D
# Output: Matriz de Reconstrução.
def createMatrizOfRemake(path, k, d)
    dna = ""
    matrizDNA = Array.new(path.length) {Array.new}
    actualColumn = 0
    line = 0
    path.each do |x|
        str = ""
        str.concat(x.sourceNode)
        for i in 1..d
            str.concat("*")
        end
        str.concat(x.destinyNode)
        str = str.split(//)
        charCount = 0
        for i in actualColumn..(str.length-1 + actualColumn)
            matrizDNA[line][i] = str[charCount]
            charCount += 1
        end
        line += 1
        actualColumn += 1
    end
    matrizDNA
end

# remakeUsingMatriz -- > Percorre uma Matriz de Reconstrução e remonta a string de DNA
# Input: Matriz de Reconstrução
# Output: String do DNA Remontado
def remakeUsingMatriz(matrizDNA)
    dna = ""
    lineCounter = 0
    for i in 0..(matrizDNA[matrizDNA.length-1].length-1)
        downCounter = 0
        if(i >= matrizDNA[0].length)
            lineCounter += 1
        end
        while(matrizDNA[lineCounter][i] == "*") do
            lineCounter += 1
            downCounter += 1
        end
        #puts "Linha : #{lineCounter} Coluna : #{i}  Letra : #{matrizDNA[lineCounter][i]}"
        dna.concat(matrizDNA[lineCounter][i])
        lineCounter -= downCounter
    end
    dna
end

# outputArchive -- > Criando Arquivo de Saída contendo o DNA Remontado
# Input: String of DNA, values of k and d
# Output: Archive.txt
def outputArchive(dna, k, d)
    arqname = "k#{k}d#{d}Remontado.txt"
    File.open(arqname, "w+") do |x|
        x.puts(dna)
    end
end

# MAIN 
kmerList = readArchive() # Resgatando lista de kmers.
d = kmerList.pop # Retirando ultimo elemento do array (D).
k = kmerList.pop # Retirando novo ultimo elemento do array (K).
dicTable = createHashID(kmerList, k) # Criando ID único para cada Kmer da lista.
deBruijn = Array.new(dicTable.length) {Array.new((dicTable.length), 0)} # Criando Matriz de Adjacência.
deBruijn = deBruijnFill(deBruijn, kmerList, dicTable, k) # Preenchendo Matriz com os prefixos->sufixos da lista de K,d-mers
orphanNode = findOrphanNode(deBruijn) # Procurando Nó sem Pai
sterileNode = findSterileNode(deBruijn) # Procurando Nó sem Filho
eulerGraph = deBruijnToEuler(deBruijn, sterileNode, orphanNode) # Transformando DeBruijn em Grafo Euleriano
path = Array.new # Criando Array de Movimentos (Movie)
path = antLeo(eulerGraph, orphanNode, path, 0, dicTable.length) # Criando Caminho Euleriano 
kPath = pathIntToStr(path, dicTable.invert) # Transformando Path Numérico em Kmers
fixedPath = fixUnion(kPath) # Unindo Prefixo com Sufixo e voltando ao Kmer original
matrizDNA = createMatrizOfRemake(fixedPath, k, d) # Criando Matriz de Reconstrução de DNA
dnaRemontado = remakeUsingMatriz(matrizDNA) # Percorrendo Matriz e Escrevendo DNA
outputArchive(dnaRemontado, k, d) # Criando Arquivo de Saída.

# Feedback
puts "Done!"
