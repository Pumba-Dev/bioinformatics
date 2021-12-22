# inputRead --> lê as sequências do arquivo passado como argumento.
# Input: Arquivo texto com as sequências.
# Output: Array com as sequências lida.
def inputRead()
    sequences = Array.new(2)
    i = 0
    File.open(ARGV[0], "r").each do |line|
        rgx = /[ACTG]+/.match(line)
        if(rgx != nil)
            sequences[i] = rgx.to_s
            i += 1
        end
    end
    sequences
end

# Cell --> Objeto que compõe as células da matriz, composto por um Inteiro e um Symbol
class Cell
    attr_accessor :num, :path

    def initialize(num, path)
        @num = num
        @path = path
    end
end

# MatrizFill --> Preenche os valores iniciais da Matriz e Calcula o resto das células.
# Input: Duas sequencias de caracteres, valores de Gap, Miss e Match
# Output: Matriz Com Valores Preenchidos.
def matrizFill(sequences, gap, miss, match)
    # Declarando Matriz
    matriz = Array.new(sequences[0].length+1) {Array.new(sequences[1].length+1)} 
    # Preenchendo Primeira Coluna com 0
    for i in 0..matriz.length-1
        matriz[i][0] = Cell.new(gap*i, nil)
    end
    # Preenchendo Primeira Linha com 0
    for i in 0..matriz[0].length-1
        matriz[0][i] = Cell.new(gap*i, nil)
    end

    # Percorrendo Matriz para calcular valores.
    for i in 1..matriz.length-1
        for j in 1..matriz[0].length-1
            # Verificando se é um Match ou MissMatch e atribuindo ao Score
            if(sequences[0][i-1] == sequences[1][j-1])
                score = match
            else
                score = miss
            end         
            #puts "#{sequences[0][i-1]} ===== #{sequences[1][j-1]}"
            # Calculando Valores dos 3 Lados
            diagonal = matriz[i-1][j-1].num + score
            topo = matriz[i-1][j].num + gap
            lado = matriz[i][j-1].num + gap
            #puts "Local: #{i}-#{j} Diagonal: #{diagonal} Topo: #{topo} Lado: #{lado}"
            # Verificando qual o Maior valor dos 3 e salvando na matriz.
            if(diagonal >= topo && diagonal >= lado)
                matriz[i][j] = Cell.new(diagonal, :DIAGONAL)
            elsif(topo >= diagonal && topo >= lado)
                matriz[i][j] = Cell.new(topo, :TOPO)
            elsif(lado >= topo && lado >= diagonal)
                matriz[i][j] = Cell.new(lado, :LADO)
            end
            #puts "Number: #{matriz[i][j].num} Path: #{matriz[i][j].path}"
        end
    end
    matriz
end

# findMaxValue --> Busca na matriz a célula com maior score.
# Input: Matriz
# Output: Coordenadas do maior valor.
def findMaxValue(matriz)
    currentNumber = 0
    currentPosition = Array.new(2)
    for i in 0..matriz.length-1
        for j in 0..matriz[0].length-1
            if(matriz[i][j].num >= currentNumber)
                currentNumber = matriz[i][j].num
                currentPosition = [i, j]
            end
        end
    end
    currentPosition
end

# LocalAlign --> Percorre a matriz de score e faz o caminho inverso do Path de cada célula da matriz.
# Input: Matriz, Sequencias para alinhamento, Posição do score mais alto, Array para salvar strings alinhadas.
# Output: Array de strings alinhadas.
def localAlign(matriz, sequences, position, strings)
    #puts "Position = #{position[0]} - #{position[1]}"
    #puts "PATH = #{matriz[position[0]][position[1]].path}"
    if(matriz[position[0]][position[1]].path == :DIAGONAL)
        strings[0] = sequences[0][position[0]-1].concat(strings[0])
        strings[1] = sequences[1][position[1]-1].concat(strings[1])
        newPosition = [position[0]-1, position[1]-1]
    elsif(matriz[position[0]][position[1]].path == :TOPO)
        strings[0] = "-".concat(strings[0])
        strings[1] = sequences[1][position[1]-1].concat(strings[1])
        newPosition = [position[0]-1, position[1]]
    elsif(matriz[position[0]][position[1]].path == :LADO)
        strings[0] = sequences[0][position[0]-1].concat(strings[0])
        strings[1] = "-".concat(strings[1])
        newPosition = [position[0], position[1]-1]
    end
    if(newPosition[0] == 0 || newPosition[1] == 0) 
        strings
    else
        localAlign(matriz, sequences, newPosition, strings)
    end
end

# PrintMatriz --> Printa o score e path de uma matriz de Cells.
# Input: Matriz
# Output: ---
def printMatriz(matriz)
    for i in 0..matriz.length-1
        for j in 0..matriz[0].length-1
            print "| #{matriz[i][j].num} - #{matriz[i][j].path}|" 
        end
        puts ""
    end
end


# OutputArchive --> Cria o arquivo de saída com as strings alinhadas e o score
# Input: Array de Strings e Score 
# Output: Archive.txt
def outputArchive(strings, score)
    File.open("output.txt", "w+") do |x|
        x.puts(strings[0])
        x.puts(strings[1])
        x.puts("Score = #{score}")
    end
end

# Main
sequences = inputRead()
m = matrizFill(sequences, ARGV[1].to_i, ARGV[2].to_i, ARGV[3].to_i)
position = findMaxValue(m)
strings = localAlign(m, sequences, position, Array.new(2, ""))
outputArchive(strings, m[position[0]][position[1]].num)