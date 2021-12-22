dicDNAtoRNA = { "A" => "U", "T" => "A", "C" => "G", "G" => "C" }
dna = ""
rna = ""
puts "Enter with DNA directory..::"
fileDirectory = gets.chomp.to_s
File.open(fileDirectory).each do |x|
        dna = dna + x
end
for i in 0..dna.length do
    if(dna[i] == ".")
        rna = rna + "."
    else
        rna = rna + dicDNAtoRNA[dna[i]].to_s
    end
end
File.open("RNA.txt", "w+") do |arq|
    arq.puts(rna)
end
system "cls" || "clear"
puts rna
puts "DONE!"
puts "Directory..: #{File.open("RNA.txt", "r").path}"
gets