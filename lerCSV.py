filename = "run11-1.csv"
step = 3
result = 2 #step.n + result
linhaDeDados = 25
total = 100

f = open(filename)
lineCount = 0
for line in f:
    lineCount+=1
    if lineCount==linhaDeDados:
        lineFinal = line

lineFinal=lineFinal.replace("\"","").replace("\n","")
value_array = lineFinal.split(",")[1:]

totalvalue = 0
index = 0

'''for i in value_array:
    if index % step != result:
        total +=1
        totalvalue+=int(i)
    index+=1

print(totalvalue/total)'''
#print(value_array)

'''
for i in range(0, len(value_array)):
    totalvalue += int(value_array[i])
    print(value_array[result])
    print(i)
    i+=step'''


for i in range(0,int(len(value_array)/step)):
    totalvalue += int(value_array[i*step+result])

print(totalvalue)
print(float(totalvalue/total))
