var numbers={};numbers.EPSILON=0.001;var basic={};basic.addition=function(arr){if(Object.prototype.toString.call(arr)==='[object Array]'){var total=0;for(var i=0;i<arr.length;i++){if(typeof(arr[i])==='number')
total=total+arr[i];else
throw new Error('All elements in array must be numbers');}
return total;}else{throw new Error('Input must be of type Array');}};basic.subtraction=function(arr){if(Object.prototype.toString.call(arr)==='[object Array]'){var total=arr[arr.length-1];for(var i=arr.length-2;i>=0;i--){if(typeof(arr[i])==='number')
total-=arr[i];else
throw new Error('All elements in array must be numbers');}
return total;}else{throw new Error('Input must be of type Array');}};basic.product=function(arr){if(Object.prototype.toString.call(arr)==='[object Array]'){var total=arr[0];for(var i=1;i<arr.length;i++){if(typeof(arr[i])==='number')
total=total*arr[i];else
throw new Error('All elements in array must be numbers');}
return total;}else{throw new Error('Input must be of type Array');}};basic.binomial=function(n,k){var arr=[];function _binomial(n,k){if(n>=0&&k===0)return 1;if(n===0&&k>0)return 0;if(arr[n]&&arr[n][k]>0)return arr[n][k];if(!arr[n])
arr[n]=[];return arr[n][k]=_binomial(n-1,k-1)+_binomial(n-1,k);}
return _binomial(n,k);};basic.factorial=function(num){var arr=[];function _factorial(n){if(n===0||n===1)return 1;if(arr[n]>0)return arr[n];else return arr[n]=_factorial(n-1)*n;}
return _factorial(num);};basic.gcd=function(num1,num2){var result;if(num1>num2){for(var i=0;i<=num2;i++){if(num2%i===0){if(num1%i===0){result=i;}}}
return result;}else if(num2>num1){for(var j=0;j<=num2;j++){if(num1%j===0){if(num2%j===0){result=j;}}}
return result;}else{result=num1*num2/num1;return result;}};basic.lcm=function(num1,num2){return Math.abs(num1*num2)/basic.gcd(num1,num2);};basic.random=function(arr,quant){if(arr.length<=quant){throw new Error('Quantity requested exceeds size of array');}else if(arr.length===0){throw new Error('Empty array');}else{return basic.shuffle(arr).slice(0,quant);}};basic.shuffle=function(array){var m=array.length,t,i;while(m){i=Math.floor(Math.random()*m--);t=array[m];array[m]=array[i];array[i]=t;}
return array;};basic.max=function(array){return Math.max.apply(Math,array);};basic.min=function(array){return Math.min.apply(Math,array);};basic.range=function(start,stop,step){var array,i=0,len;if(arguments.length<=1){stop=start||0;start=0;}
step=step||1;if(stop<start){step=0-Math.abs(step);}
len=Math.max(Math.ceil((stop-start)/step)+1,0);array=new Array(len);while(i<len){array[i++]=start;start+=step;}
return array;}
numbers.basic=basic;var calculus={};calculus.pointDiff=function(func,point){var a=func(point-1e-15);var b=func(point+1e-15);return(b-a)/(2e-15);};calculus.riemann=function(func,start,finish,n,sampler){var inc=(finish-start)/n,totalHeight=0,i;if(typeof sampler==='function'){for(i=start;i<finish;i+=inc){totalHeight+=func(sampler(i,i+inc));}}else{for(i=start;i<finish;i+=inc){totalHeight+=func(i);}}
return totalHeight*inc;};function simpsonDef(func,a,b){var c=(a+b)/2;var d=Math.abs(b-a)/6;return d*(func(a)+4*func(c)+func(b));}
function simpsonRecursive(func,a,b,whole,eps){var c=a+b,left=simpsonDef(func,a,c),right=simpsonDef(func,c,b);if(Math.abs(left+right-whole)<=15*eps){return left+right+(left+right-whole)/15;}else{return simpsonRecursive(func,a,c,eps/2,left)+simpsonRecursive(func,c,b,eps/2,right);}}
calculus.adaptiveSimpson=function(func,a,b,eps){eps=(typeof eps==="undefined")?numbers.EPSILON:eps;return simpsonRecursive(func,a,b,simpsonDef(func,a,b),eps);};calculus.limit=function(func,point,approach){if(approach==='left'){return func(point-1e-15);}else if(approach==='right'){return func(point+1e-15);}else if(approach==='middle'){return(calculus.limit(func,point,'left')+calculus.limit(func,point,'right'))/2;}else{throw new Error('Approach not provided');}};numbers.calculus=calculus;var matrix={};matrix.addition=function(arrA,arrB){if((arrA.length===arrB.length)&&(arrA[0].length===arrB[0].length)){var result=new Array(arrA.length);for(var i=0;i<arrA.length;i++){result[i]=new Array(arrA[i].length);for(var j=0;j<arrA[i].length;j++){result[i][j]=arrA[i][j]+arrB[i][j];}}
return result;}else{throw new Error('Matrix mismatch');}};matrix.scalar=function(arr,val){for(var i=0;i<arr.length;i++){for(var j=0;j<arr[i].length;j++){arr[i][j]=val*arr[i][j];}}
return arr;};matrix.transpose=function(arr){var result=new Array(arr[0].length);for(var i=0;i<arr[0].length;i++){result[i]=new Array(arr.length);for(var j=0;j<arr.length;j++){result[i][j]=arr[j][i];}}
return result;};matrix.identity=function(n){var result=new Array(n);for(var i=0;i<n;i++){result[i]=new Array(n);for(var j=0;j<n;j++){result[i][j]=(i===j)?1:0;}}
return result;};matrix.dotproduct=function(vectorA,vectorB){if(vectorA.length===vectorB.length){var result=0;for(var i=0;i<vectorA.length;i++){result+=vectorA[i]*vectorB[i];}
return result;}else{throw new Error("Vector mismatch");}};matrix.multiply=function(arrA,arrB){if(arrA[0].length===arrB.length){var result=new Array(arrA.length);for(var x=0;x<arrA.length;x++){result[x]=new Array(arrB[0].length);}
var arrB_T=matrix.transpose(arrB);for(var i=0;i<result.length;i++){for(var j=0;j<result[i].length;j++){result[i][j]=matrix.dotproduct(arrA[i],arrB_T[j]);}}
return result;}else{throw new Error("Array mismatch");}};matrix.determinant=function(m){if((m.length===2)&&(m[0].length===2)){return m[0][0]*m[1][1]-m[0][1]*m[1][0];}else if((m.length===3)&&(m[0].length===3)){return m[0][0]*m[1][1]*m[2][2]+
m[0][1]*m[1][2]*m[2][0]+
m[0][2]*m[1][0]*m[2][1]-
m[0][2]*m[1][1]*m[2][0]-
m[0][1]*m[1][0]*m[2][2]-
m[0][0]*m[1][2]*m[2][1];}else{throw new Error('Matrix must be dimension 2 x 2 or 3 x 3');}};numbers.matrix=matrix;var prime={};prime.simple=function(val){if(val===1)return false;else if(val===2)return true;else if(val!==undefined){var start=1;var valSqrt=Math.ceil(Math.sqrt(val));while(++start<=valSqrt){if(val%start===0){return false;}}
return true;}};numbers.prime=prime;var statistic={};statistic.mean=function(arr){var count=arr.length;var sum=basic.addition(arr);return sum/count;};statistic.median=function(arr){var sorted=arr.slice(0);sorted.sort();var count=sorted.length;var middle;if(count%2===0){return(sorted[count/2]+sorted[(count/2-1)])/2;}else{return sorted[Math.floor(count/2)];}};statistic.mode=function(arr){var counts={};for(var i=0,n=arr.length;i<n;i++){if(counts[arr[i]]===undefined)
counts[arr[i]]=0;else
counts[arr[i]]++;}
var highest;for(var number in counts){if(counts.hasOwnProperty(number)){if(highest===undefined||counts[number]>counts[highest])
highest=number;}}
return Number(highest);};statistic.randomSample=function(lower,upper,n){var sample=[];var temp=0;for(var i=0;i<n;i++){temp=Math.random()*upper;if(temp>lower)
sample[i]=temp;}
return sample;};statistic.standardDev=function(arr){var count=arr.length;var mean=statistic.mean(arr);var squaredArr=[];for(var i=0;i<arr.length;i++){squaredArr[i]=Math.pow((arr[i]-mean),2);}
return Math.sqrt((1/count)*basic.addition(squaredArr));};statistic.correlation=function(arrX,arrY){if(arrX.length==arrY.length){var numerator=0;var denominator=(arrX.length)*(statistic.standardDev(arrX))*(statistic.standardDev(arrY));var xMean=statistic.mean(arrX);var yMean=statistic.mean(arrY);for(var i=0;i<arrX.length;i++){numerator+=(arrX[i]-xMean)*(arrY[i]-yMean);}
return numerator/denominator;}else{throw new Error('Array mismatch');}};statistic.rSquared=function(source,regression){function square(x){return x*x;}
var residualSumOfSquares=basic.addition(source.map(function(d,i){return square(d-regression[i]);}));var totalSumOfSquares=basic.addition(source.map(function(d){return square(d-statistic.mean(source))}));return 1-(residualSumOfSquares/totalSumOfSquares);}
statistic.exponentialRegression=function(arrY){var n=arrY.length;var arrX=basic.range(1,n);var xSum=basic.addition(arrX);var ySum=basic.addition(arrY);var yMean=statistic.mean(arrY);var yLog=arrY.map(function(d){return Math.log(d);});var xSquared=arrX.map(function(d){return d*d;});var xSquaredSum=basic.addition(xSquared);var yLogSum=basic.addition(yLog);var xyLog=arrX.map(function(d,i){return d*yLog[i];});var xyLogSum=basic.addition(xyLog);var a=(yLogSum*xSquaredSum-xSum*xyLogSum)/(n*xSquaredSum-(xSum*xSum));var b=(n*xyLogSum-xSum*yLogSum)/(n*xSquaredSum-(xSum*xSum));var fn=function(x){if(typeof x=='number'){return Math.exp(a)*Math.exp(b*x);}else{return x.map(function(d){return Math.exp(a)*Math.exp(b*d);});}};fn.rSquared=statistic.rSquared(arrY,arrX.map(fn));return fn;}
statistic.linearRegression=function(arrX,arrY){var n=arrX.length;var xSum=basic.addition(arrX);var ySum=basic.addition(arrY);var xySum=basic.addition(arrX.map(function(d,i){return d*arrY[i];}));var xSquaredSum=basic.addition(arrX.map(function(d){return d*d;}));var xMean=statistic.mean(arrX);var yMean=statistic.mean(arrY);var b=(xySum-1/n*xSum*ySum)/(xSquaredSum-1/n*(xSum*xSum));var a=yMean-b*xMean;return function(x){if(typeof x=='number'){return a+b*x;}else{return x.map(function(d){return a+b*d;});}}}
numbers.statistic=statistic;var useless={};useless.collatz=function(n,result){result.push(n);if(n==1){return;}else if(n%2===0){useless.collatz(n/2,result);}else{useless.collatz(3*n+1,result);}};numbers.useless=useless;