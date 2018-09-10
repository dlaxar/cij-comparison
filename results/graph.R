benchmarks = list()
tests = c('BubbleSort', 'Fibonacci', 'Fractions', 'HashMap', 'List', 'MergeSort')

i = 1
for(test in tests) {
  benchmarks[[i]] = read.csv2(paste(test, 'csv', sep='.'), header=FALSE, dec='.')
  i = i + 1
}

bubble = read.csv2('BubbleSort.csv', header=FALSE)

engines = c('OpenJDK (default)', 'OpenJDK (-Xint)', 'OpenJDK (JIT)', 'Zulu', 'CIJ jit', 'CIJ int')
jit = c('OpenJDK (default)', 'OpenJDK (JIT)', 'Zulu', 'CIJ jit')
int = c('OpenJDK (-Xint)', 'CIJ int')
timings = c('ns', 'return', 'real', 'user', 'sys')
jittimings = c('ns')
inttimings = c('ns')
col = 3
names = c('experiment', 'round')
jitnames = c()
intnames = c()

for(engine in engines) {
  for(time in timings) {
    names[col] = paste(engine, time, sep = ": ")
    col = col + 1
  }
}

for(engine in jit) {
  for(time in jittimings) {
    jitnames[length(jitnames)+1] = paste(engine, time, sep = ": ")
  }
}

for(engine in int) {
  for(time in inttimings) {
    intnames[length(intnames)+1] = paste(engine, time, sep = ": ")
  }
}

i = 1
for(test in tests) {
  colnames(benchmarks[[i]]) <- names
  i = i + 1
}



avgs = matrix(0:0, nrow=length(tests), ncol=length(names))
  
i = 1
for(test in tests) {
  n = 1
  for(name in names) {
    if(identical(name, '') || identical(name, 'experiment') || identical(name, 'round') || grepl('return', name)) {
      n = n + 1
      next
    }
    options(digits=15)
    avgs[i, n] = mean(as.numeric(benchmarks[[i]][[name]]))
    
    if(grepl('ns', name)) {
      avgs[i, n] = avgs[i, n]  / 1e9
    }
    
    n = n + 1
  }
  i = i + 1
}

rownames(avgs) <- tests
colnames(avgs) <- names

data = t(avgs[,jitnames])

dataspaced=rbind(NA,data)

require(plotrix)

width = 800
height = 600

allcolors = rainbow(length(engines))
colors = allcolors[1:length(rownames(data))]
intcolors = allcolors[seq(length(rownames(data))+1, length(allcolors))]
colorsspaced = c('black', colors)

png('overview-jit.png', width=width, height=height)
layout(matrix(1:2, nrow=1,ncol=2), widths=c(.8, .2))

a = gap.barplot(dataspaced,
                gap=c(2e1,4e1),
                xaxt='n',
                col=rep(colorsspaced, 6),
                ytics=c(seq(0, 20, 2),42,44),
                ylab="Runtime [s]",
                xlab="Testcase")

aa = matrix(a, nrow=nrow(dataspaced))
xticks = colMeans(aa[2:nrow(dataspaced),])

# add axis labels at mean position
axis(1, at=xticks, lab=colnames(dataspaced))

par(xpd = NA, mar = c(5,0,4,2))
plot(matrix(2),xlim = c(0,1), ylim=c(0,1),xlab="",ylab="",xaxt='n',yaxt='n',bty='n',yaxs='i',xaxs='i')
legend(0, 1, fill=colors, legend=jit)
dev.off()

png('details-jit.png', width=width, height=height)
par(mfrow=c(1,1))
par(xpd = TRUE, mar = c(5,4,4,2) + c(0,0,0,9))
barplot(data,
        beside=TRUE,
        ylim=c(0, 4),
        col=colors,
        ylab="Runtime [s]",
        xlab="Testcase")
legend(32, 4, fill=colors, legend=jit)
box()
dev.off()

intdata = t(avgs[,intnames])

png('overview-int.png', width=width, height=height)
par(xpd=TRUE, mar=c(5,4,4,2) + c(0,0,0,10))
barplot(intdata,
        beside=TRUE,
        col=intcolors,
        ylab="Runtime [s]",
        xlab="Testcase", 
        yaxs='i',
        ylim=c(0, 130))
legend(20, 130, fill=intcolors, legend=int)
box()
dev.off()

par(mar=c(5, 4, 4, 2) + 0.1)
