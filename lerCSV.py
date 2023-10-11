filename = "TrabalhoPratico experiment-spreadsheet.csv"
step = 2
result = 0 #step.n + result
linhaDeDados = 25

f = open(filename)
lineCount = 0
for line in f:
    lineCount+=1
    if lineCount==linhaDeDados:
        lineFinal = line

lineFinal=lineFinal.replace("\"","").replace("\n","")
value_array = lineFinal.split(",")[1:]

total = totalvalue = index = 0

for i in value_array:
    if index % step != result:
        total +=1
        totalvalue+=int(i)
    index+=1

print(totalvalue/total)