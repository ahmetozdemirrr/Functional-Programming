# Haskell Programming Languages Notes



## Chapter 1: Introduction

Haskell saf bir fonksiyonel programlama dilidir. Klasik imperative dillerde biz bilgisayara yapması gereken bir dizi görev veririz ve bunu yapmasını bekleriz. Ancak bu görevler yerine getirilirken programda stateler veya değişkenlerin içeriği değişebilir. Fonksiyonel diller bağlamında biz bu duruma "side effect" deriz. Ayrıca bazı taskların ard arda defalarca yapılabilmesini sağlayan for, while gibi döngüsel akış kontrol yapıları vardır. 

Haskell bu şekilde çalışmaz; öncelikle bilgisayara ne yapması gerektiğini söylemezsiniz sadece nasıl yapılacağını söylersiniz, mesela bir factorial hesabı için "elde edilecek değer sayının kendisinden 1'e kadar olan tüm sayıların çarpımı şeklindedir" gibi bir tanım yapılabilir. Bu ve bunun gibi tanımlar "function"'lar ile açıklayabiliriz.

Bu dilde implemente ettiğimiz fonksiyonlar hiçbir zaman body'sinde bir değişkenin değerini değiştirmez ki pure functional tanımımız bunun yapılamıyor oluşundan gelir. Çünkü side effect istemeyiz. Fonksiyonların tek yaptığı şey bir şeyler hesaplamak ve sonucunu return etmektir. Bu durumun bir fonksiyon iki kere çağrıldığı zaman her iki seferde de aynı sonucu vereceğini garanti eder bu özelliğe "referrantial transparency" denir. Bu tür küçük küçük fonksiyonlar birleştirilerek daha kompleks ve side effect'i olmayan fonksiyonlar yaratılabilir.



- Side effect nedir?
	Programlama dillerinde "side effect", bir fonksiyonun veya expressionun, sadece bir değer döndürmenin dışında, çağrıldığı kapsamın dışındaki bir durumu değiştirmesi veya dış dünyayla etkileşime girmesi anlamına gelir. Saf fonksiyonlar aynı girdilerle her zaman aynı çıktıyı üretirken, yan etkisi olan bir fonksiyonun davranışı dış faktörlere bağlı olarak değişebilir. Örneğin, bir fonksiyonun kendi kapsamı dışındaki global bir değişkenin değerini değiştirmesi en yaygın yan etkilerden biridir. Bir dosyaya veri yazmak, bir veritabanı sorgusu çalıştırmak, ekrana bir şey yazdırmak veya bir ağ isteği göndermek de yan etki olarak kabul edilir çünkü bu işlemler programın yerel ortamının dışındaki sistemleri etkiler.



Haskell dili ayrıca **lazy** bir özelliğe sahiptir bunun anlamı şudur; aksi belirtilmediği sürece veya ilgili fonksiyonun çalışması gerekmediği sürece fonksiyonlar yürütülmez. Yani bir nevi iş yükünü her zaman erteleme eğiliminde olan bir dildir. **Laziness** ayrıca, yalnızca sonucunu hesaplamasını istediğini bir işlemin sonucunu hesapladığı için, görünüşte sonsuz veri yapıları oluşturmanıza da olanak sağlar. 



```haskell
xs = [1, 2, 3, 4, 5, 6, 7, 8]
let lazy_result = doubleMe(doubleMe(doubleMe(xs)))
```



Imperative bir dilde bu kod satırlarından hemen sonra bellekte bu arrayin birkaç tane kopyası oluşur ve tüm verinin gerçekten de 3 kere 2 katı alınmış hali bellekte hazır tutulur. Ancak Haskell burada **Laziness** sayesinde "tamam, bana ne yapacağımı söyledin zamanı geldiğinde bunu yapacağım" der. 



```haskell
head lazy_result -- head listenin ilk elemanını veren built-in bir fonksiyondur
```



**Haskell** burada o ertelediği işi şimdi yapar ve sadece bunu ilk eleman için yapar yani `doubleMe(doubleMe(doubleMe(1)))`.



Haskell **statically typed** bir dildir, bunun anlamı compiler programı derlerken her değişkenin tipini bilir, bu sayede birçok type error derleme zamanında yakalanır. Haskell **type inference** özelliğini kullanan çok güçlü bir tip sistemi kullanır. Yani her bir kod parçası için bunun tipi budur demenize gerek yoktur, kendisi kullanılan değişkenlerin tipinden bunu çıkarabilir, ancak kullanılan değişken tipleri uyumsuzsa bu da derleme zamanı hatası olarak döner.



**GHCi Kullanımı:**

```haskell
-- arithmetic operations:
ghci> 2 + 15
17
ghci> 49 * 100
4900
ghci> 1892 - 1472
420
ghci> 5 / 2
2.5
ghci> 50 * 100 - 4999
1

-- booelan operations:
ghci> True && False
False
ghci> True && True
True
ghci> False || True
True
ghci> not False
True
ghci> not (True && True)
False
ghci> 5 == 5
True
ghci> 1 == 0
False
ghci> 5 /= 5 -- eşit değildir anlamına gelir (!= gibi)
False
ghci> 5 /= 4
True
ghci> "hello" == "hello"
True
```

Bu işlemler sadece geçerli tipler arasında yapılabilir.

---



## Chapter 2: Starting Out

**Function calls:**

Haskell'de aritmetik operatörler de aslında birer fonksiyondur, tabii fonksiyon çağrıları farklı fiziksel formlarda olabilir. Mesela bir operatöre parametre verirken `infix` olarak verebiliriz: `a + b` gibi, ya da genelde olduğu gibi `prefix` olabilir: `succ 8`.

```haskell
ghci> min 9 10
9
ghci> min 3.4 3.2
3.2
ghci> max 100 101
101
```

fonksiyonlar en yüksek önceliğe sahip olur:

```haskell
-- both are equivalent
ghci> succ 9 + max 5 4 + 1
16
ghci> (succ 9) + (max 5 4) + 1
16
-- yani kısaca şöyle yazamayız:
ghci> succ 9 * 10 -- bunun sonucu 100 olur, ancak biz 9*1O'nun bir fazlasını istersek:
ghci> succ (9 * 10) -- şeklinde bir çağrı yapabiliriz
```



**A function sample:**

Burada bir fonksiyon yazmak için önce bir dosya açın (main.hs) ve içerisine şu fonksiyonu yazın, ardından terminalden bu fonksiyonu kullanabileceğiz:

```haskell
doubleMe x = x + x
doubleUs x y = x * 2 + y * 2
```

```haskell
ghci> :l main -- linking the source file
[1 of 1] Compiling Main         ( main.hs, interpreted )
Ok, modules loaded: Main.
ghci> doubleMe 9
18
ghci> doubleMe 3.2
6.4
ghci> doublUs 4 9
26
ghci> doubleUs 2.3 34.2
73.0
ghci> doubleUs 28 88 + doubleMe 123
478
```

`doubleUs` fonksiyonu şu şekilde de yazılabilirdi: `doubleUs x y = doubleMe x + doubleMe y`.  Başka bir örnek:

```haskell
doubleSmallNumber x = if x > 100
                      then x
                      else x*2
-- verilen sayı eğer 100'den büyükse çarpım yapılmaz
```

Haskell'de kullanılan her `if` için kesinlikle bir `else` de olmalıdır.



**List'lere giriş:**

Haskell'de listeler homojen veri yapılarıdır yani aynı anda sadece tek tipte veriler barındırabilirler. 

```haskell
ghci> let lostNumbers = [4,8,15,16,23,42]
ghci> lostNumbers
[4,8,15,16,23,42]
```

*GHCi'de bir isim tanımlamak için let anahtar sözcüğünü kullanın. GHCi'de let a = 1 girmek, bir betiğe a = 1 yazmaya ve sonra onu :l ile yüklemeye eşdeğerdir.*

- **Concatenation:**

```haskell
ghci> [1,2,3,4] ++ [9,10,11,12]
[1,2,3,4,9,10,11,12]
ghci> "hello" ++ " " ++ "world"
"hello world"
ghci> ['w','o'] ++ ['o','t']
"woot"
```

Haskell'de stringler aslında karakter dizileri olarak saklanır: "hello" -> ['h','e','l','l','o'].

```haskell
ghci> 'A':" SMALL CAT"
"A SMALL CAT"
ghci> 5:[1,2,3,4,5]
[5,1,2,3,4,5]
```

**: (cons)** operatörü ile listenin başına da ekleme yapabiliriz. Haskell'de `[]` ifadesi empty list anlamına gelir yani şu şekilde bir şey yazılabilir: `ghci> 1:2:3:[]` bu [1, 2, 3] sonucunu üretir. 



* **Accesing list elements:**

```haskell
ghci> "Steve Buscemi" !! 6
'B'
ghci> [9.4,33.2,96.2,11.2,23.25] !! 1
33.2
```



* **Liste içinde liste:**

```haskell
ghci> let b = [[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
ghci> b
[[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
ghci> b ++ [[1,1,1,1]]
[[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3],[1,1,1,1]]
ghci> [6,6,6]:b
[[6,6,6],[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
ghci> b !! 2
[1,2,2,3,4]
ghci> b
[[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
```

görüldüğü üzere liste ile yapılan işlemler listenin kendisini değiştirmemiştir. 



* **Listeleri karşılaştırma:**

<, >, <= ve >= gibi operatörleri listeler üzerinde kullandığımız zaman lexicographic sırayla karşılaştırılırlar. 

```haskell
ghci> [3,2,1] > [2,1,0]
True
ghci> [3,2,1] > [2,10,100]
True
ghci> [3,4,2] < [3,4,3]
True
ghci> [3,4,2] > [2,4]
True
ghci> [2] > [1, 100]
True
ghci> [3,4,2] == [3,4,2]
True
```



* **Other List Operations:**

```haskell
ghci> head [5,4,3,2,1]
5
ghci> tail [5,4,3,2,1]
[4,3,2,1]
ghci> last [5,4,3,2,1]
1
ghci> init [5,4,3,2,1] # everything except last elem
[5,4,3,2]
ghci> head []
*** Exception: Prelude.head: empty list
ghci> length [5,4,3,2,1]
5
ghci> null [1,2,3]
False
ghci> null []
True
ghci> reverse [5,4,3,2,1]
[1,2,3,4,5]
ghci> take 3 [5,4,3,2,1]
[5,4,3]
ghci> take 1 [3,9,3]
[3]
ghci> take 5 [1,2]
[1,2]
ghci> take 0 [6,6,6]
[]
-- t drops the specified number of elements from the beginning of a list:
ghci> drop 3 [8,4,2,1,5,6]
[1,5,6]
ghci> drop 0 [1,2,3,4]
[1,2,3,4]
ghci> drop 100 [1,2,3,4]
[]
ghci> maximum [1,9,2,3,4]
9
ghci> minimum [8,4,2,1,5,6]
1
ghci> sum [5,2,1,6,3,2,5,7]
31
ghci> product [6,2,1,2]
24
ghci> product [1,2,5,6,7,9,2,0]
0
-- elem genelde infix olarak kullanılır, Haskell'de çift operatörlü fonksiyonların infix formu şu şekilde kullanılır:
ghci> 4 `elem` [3,4,5,6]
True
ghci> 10 `elem` [3,4,5,6]
False
```



**Ranges:**

Enumerate edilebilen verileri bazen direkt olarak bir arrayın içine yazmaktansa derleyici tarafından doldurulmasını bekleyebiliriz. Haskell'de bunun için **range** kullanılır. Aşağıdaki örneklerden bunu anlayabiliriz:

```haskell
ghci> [1..20]
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
ghci> ['a'..'z']
"abcdefghijklmnopqrstuvwxyz"
ghci> ['K'..'Z']
"KLMNOPQRSTUVWXYZ"
```

burada ilk sayıdan son sayıya kadar tüm elemanlar sıralanır, ayrıca aşağıdaki gibi durma noktası da belirtebiliriz. Burada; ilk parametre örüntünün ilk elamanını, ikinci parametre ikinci elemanını belirtirken son parametre de dizinin sınırını belirler. 

```haskell
ghci> [2,4..20]
[2,4,6,8,10,12,14,16,18,20]
ghci> [3,6..20]
[3,6,9,12,15,18]
```

Tabii range kullanımında derleyici her kompleks örüntüyü anlayıp buna göre devamını dolduramaz, yukarıda verdiğimiz gibi aritmetik örüntülerde kullanılır. 

---

**Not:** 20'den 1'e kadar sayıları elde etmek istediğinizde bunu `[20..1]` şeklinde yazmamalıyız, çünkü derleyicinin yaptığı ilk işlemlerden biri verilen sayıların ilkinin birincisinden büyük olup olmamasıdır. Böyle bir durumda direkt boş bir liste elde ederiz. İstediğimizi yapabilmek için ` [20,19..1]` gibi bir direktif vermeliyiz.

---

Diyelim ki 13'ün ilk 24 katını veren bir dizi oluşturmak istiyoruz, bunu yapabilmek için şöyle bir şey yazabiliriz:

```haskell
ghci> [13,26..24*13]
[13,26,39,52,65,78,91,104,117,130,143,156,169,182,195,208,221,234,247,260,273,286,299,312]
```

ancak daha efektif bir yöntem sonsuz liste kullanmaktır, Haskell lazy evaluation yaptığı için sadece istediğiniz yere kadar olan kısmı işler:

```haskell
ghci> take 24 [13,26..]
[13,26,39,52,65,78,91,104,117,130,143,156,169,182,195,208,221,234,247,260,273,286,299,312]
```

Aşağıda çok uzun ve sonsuz listeler için kullanılan bazı fonksiyonlar verilmiştir:

* `cycle`:

```haskell
ghci> take 10 (cycle [1,2,3])
[1,2,3,1,2,3,1,2,3,1]
ghci> take 12 (cycle "LOL ")
"LOL LOL LOL "
```

* `repeat`:

```haskell
ghci> take 10 (repeat 5)
[5,5,5,5,5,5,5,5,5,5]
```

* `replicate`:

```haskell
ghci> replicate 3 10
[10,10,10]
```



**List Comprehensions:**

List comprehension (liste sıkıştırma), listeleri filtreleme, dönüştürme ve birleştirme işlemlerini yapabilmemizi sağlayan bir yoldur. Matematikteki `set comprehensions` kavramına çok benzerdir, zaten Haskell'in amacı matematiksel bir saflığa yakın olmak olduğundan bu durum doğal karşılanabilir. 

Matematikte basit bir küme oluşturma işlemi:

```mathematica
{2 · x | x ∈ N, x ≤ 10}
```

yani burada "10 ve 10'dan küçük tüm doğal sayıları al ve bunları 2 ile çarparak kümeme ekle" işlemi yaptırılmaya çalışılıyor. Haskell'de buna benzer bir şey yapabilmek için önceki sayfalarda gördüğümüz gibi range kullanabiliriz:

```haskell
take 10 [2,4..]
```

ancak, list comprehensionın bu durumda tercih edilmesi daha efektiftir, çünkü daha kompleks işlemleri de daha kolay yaptırabilir.

```haskell
ghci> [x*2 | x <- [1..10]]
[2,4,6,8,10,12,14,16,18,20]
```

Bu satırda aslında şunu demek istiyoruz:

1) Kullanacağımız elemanlar **[1..10]** listesi olacak.
2) **x <- [1..10]** bu verdiğim listeyi gez ve her döngüde current elemanı x'in içind koy.
3) Pipe (|) operatöründen önceki kısım da bizim outputumuzu kurduğumuz yer olacak, **x** ile aldığımız her elemanı 2 ile çarp ve listeye ekle.

Bu yöntem ilkinden daha karmaşık görünebilir ancak daha kompleks işlemleri yapabilmek için range veya benzer kullanımlar bizi kurtaramaz. Mesela listeyi ilk oluşturduğumuz kısıma condition'lar (buna ayrıca **predicate** denir) ekleyip listeleri daha karmaşık şekillerde oluşturabiliriz. Bu condition'lar listenin en sonuna yazılır ve diğer kısımlardan virgülle ayrılır.

```haskell
ghci> [x*2 | x <- [1..10], x*2 >= 12]
[12,14,16,18,20]
```

burada programdan sadece 2 ile çarpımı 12'den büyük olan sayıları output'a eklemesini istiyoruz. Ya da belki sadece 7 ile modu 3 olan sayılar olsun isteyebiliriz:

```haskell
ghci> [ x | x <- [50..100], x `mod` 7 == 3]
[52,59,66,73,80,87,94]
```

Listeleri **predicate**'ler kullanarak ayırmaya filtreleme denir. 



Aşağıda bazı daha detaylı örnekler verilmiştir:

```haskell
boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
```

burada elimizde `xs` adında bir liste olduğunu düşünelim, bu listedeki tek olan elemanların yerine 10'dan büyük veya küçük olması ilişkilerine göre "BOOM" veya "BANG" yazdırıyoruz. 

```haskell
ghci> xs =  [1..15]
ghci> boomBangs xs
["BOOM!","BOOM!","BOOM!","BOOM!","BOOM!","BANG!","BANG!","BANG!"]
```

Comprehension ifadesinin içine birden fazla **predicate** yazabiliriz:

```haskell
ghci> [ x | x <- [10..20], x /= 13, x /= 15, x /= 19]
[10,11,12,14,16,17,18,20]
```

Sadece tek listeyle değil aynı anda birden fazla liste kullanarak da bu ifadeleri yazabiliriz. Aşağıda buna yönelik örnekler verilmiştir. 

```haskell
ghci> [x+y | x <- [1,2,3], y <- [10,100,1000]]
[11,101,1001,12,102,1002,13,103,1003]
```

burada her iki listedeki elemanları teker teker x ve y ile dolaşır ardından bunları toplayıp yeni listeye atarız. Tüm kombinasyonların uygulandığına dikkat ediniz. Stringler üzerinden bir örnek:

```haskell
ghci> let nouns = ["hobo","frog","pope"]
ghci> let adjectives = ["lazy","grouchy","scheming"]
ghci> [adjective ++ " " ++ noun | adjective <- adjectives, noun <- nouns]
["lazy hobo","lazy frog","lazy pope","grouchy hobo","grouchy frog",
"grouchy pope","scheming hobo","scheming frog","scheming pope"]
```



**List Comprehension ile kendi Length fonksiyonumu yazma:**

```haskell
length' xs = sum [1 | _ <- xs]
```

xs'in her elemanını al ve değeri farketmeksizin (_) bunun için sıkıştırdığımız listeye bir tane 1 ekle, ardından `sum` ile tüm listenin elemanlarını topla. Burada `_` ifadesini bir geçici değişken olarak kullanıyoruz, aslında başka bir şekilde de bunu alabilirdik listeden ancak her eleman için aynı işlemi yapacağımızdan dolayı buna gerek olmadan sadece varlık kontrolü yapıyoruz.



**Örnek:**

```haskell
removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]
```

```haskell
ghci> removeNonUppercase "Hahaha! Ahahaha!"
"HA"
ghci> removeNonUppercase "IdontLIKEFROGS"
"ILIKEFROGS"
```

iç içe listelerde de aşağıdaki gibi kullanılabilir:

```haskell
ghci> let xxs = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]]
ghci> [ [ x | x <- xs, even x ] | xs <- xxs]
[[2,2,4],[2,4,6,8],[2,4,2,6,2,6]]
```

comprehension ifadesinin dış kısmında içerideki listeleri dolaş, içerideki diğer listede de her bir iç liste üzerinde çalış. 

---

Çok uzun olabilecek comprehension ifadelerini kod yazarken okunabilirlik artabilsin diye satırlara ayırabilirsiniz. 

```haskell
boomBang out = [ if x < 10 then "BOOM!" else "BANG!" | 
                 x <- [0..15], 
                 odd x ]
```

---



**Tuples (demet):**

Tuple'lar birkaç heterojen elementi bir tekil değer gibi tutmamızı sağlayan veri yapılarıdır. Listelerden en büyük farkları heterojen olabilmelidir ayrıca boyutları katı bir şekilde sabittir.

```haskell
ghci> (1, 3)
(1,3)
ghci> (3, 'a', "hello")
(3,'a',"hello")
ghci> (50, 50.4, "hello", 'b')
(50,50.4,"hello",'b')
```

Tuple'lar görünürde listelere benzese de aralarında önemli farklılıklar vardır mesela iki boyutlu bir düzlem için bir koordinat sistemi kullanmak istiyorurz diyelim. Bunun için her nokta için hem x hem de y'yi tutan bir veri yapısına ihtiyacımız var, burada hem liste hem de tuple kullanacağımız senaryolara bakalım:

Liste kullanırsak şöyle bir şeyler olur: `[[1,2],[8,11],[4,5]]` ve bu veri yapısının tanımı (daha teknik olarak *tip*i) **list of lists** olarak yapılır. Ancak `[[1,2],[8,11,5],[4,5]]` listesi de aynı şekilde tanımlanır... Unutmamalıyız ki Haskell'in en önemli özelliklerinden biri tip sistemi üzerine yoğunlaşmasıdır; bu, fonksiyon yazmamızı, vektörleri ve shape'leri manipüle etmemizi zorlaştırır dolayısııyla bu tarz bir durum isteyeceğimiz bir durum değildir. Tersine **tuple**'larda boyut değiştikçe veri yapısının tipi de değişir, mesela ikili çiftler barındıran tuple'lara `pair` denirken üç eleman tutan tuple'lara `triple` denir.

* Listeler ile:

```haskell
ghci> [[1,2],[8,11,5],[4,5]]
[[1,2],[8,11,5],[4,5]]
```

görüldüğü üzere içerideki değerler aslında farklı olmasına rağmen bir tip hatası vermedi çünkü her bir koordinat noktasını burada **list of lists** olarak görüyor.

* Tuple'lar ile:

```
ghci> [(1,2),(8,11,5),(4,5)]
Couldn't match expected type `(t, t1)'
against inferred type `(t2, t3, t4)'
In the expression: (8, 11, 5)
In the expression: [(1, 2), (8, 11, 5), (4, 5)]
In the definition of `it': it = [(1, 2), (8, 11, 5), (4, 5)]
```

ancak burada ortadaki nokta bir triple iken diğer ikisi pair olduğu için bir tip hatası üretiyor. Unutmayın ki listeler her zaman tek bir tür barındırabilir, aslında tamamen anlatmaya çalıştığımız şey bu. Bir tuple boyutuna göre farklı tiplere bürünür, bu tarz senaryolarda hangi veri yapılarını kullanacağımızı özenle seçmeliyiz. Ayrıca `[(1,2),("One",2)]` gibi bir kullanım da hata verecektir, burada boyutlardan ziyade tuple 'ların tuttuğu iç değerlerin tipi farklıdır. Doğal olarak bu tuple'ın kendi tipine de etki eder.

Listeler gibi, bileşenleri karşılaştırılabiliyorsa tuple'lar birbirleriyle karşılaştırılabilir. Ancak, listelerin aksine, farklı boyutlardaki iki tuple'ı karşılaştıramazsınız. Singleton list olsa da tuple'lar da böyle bir özellik yoktur. 

**Using Pairs:**

```haskell
ghci> fst (8, 11)
8
ghci> fst ("Wow", False)
"Wow"
```

`fst` bize tuple'ın ilk elemanını verir. `snd` de ikinci elemanını verir:

```haskell
ghci> snd (8, 11)
11
ghci> snd ("Wow", False)
False
```

unutmamalıyız ki bu iki operatör sadece **pair**'ler için çalışır. Aksi halde:

```haskell
ghci> fst (8, 11, 15)

<interactive>:22:5: error:
    • Couldn't match expected type: (a, b0)
                  with actual type: (a0, b1, c0)
    • In the first argument of ‘fst’, namely ‘(8, 11, 15)’
      In the expression: fst (8, 11, 15)
      In an equation for ‘it’: it = fst (8, 11, 15)
    • Relevant bindings include it :: a (bound at <interactive>:22:1)
```



**zip** fonksiyonu kullanılarak iki liste birleştirilerek bir tuple listesi oluşturulabilir:

```haskell
ghci> zip [1,2,3,4,5] [5,5,5,5,5]
[(1,5),(2,5),(3,5),(4,5),(5,5)]
ghci> zip [1..5] ["one", "two", "three", "four", "five"]
[(1,"one"),(2,"two"),(3,"three"),(4,"four"),(5,"five")]
```

değişik boyutta listeleri input olarak verdiğimizde daha küçük boyutta olan listeyi dikkate alır geriye kalan elemanları işlemez:

```haskell
ghci> zip [1,2,3,4,6,5] [5,5,5,5,5]
[(1,5),(2,5),(3,5),(4,5),(6,5)]
```

Pratik bir örnek:

```haskell
ghci> zip [1..] ["apple", "orange", "cherry", "mango"]
[(1,"apple"),(2,"orange"),(3,"cherry"),(4,"mango")]
```

```haskell
ghci> let rightTriangles' = [ (a,b,c) | c <- [1..10], a <- [1..c], b <- [1..a], a^2 + b^2 == c^2, a+b+c == 24]
ghci> rightTriangles' 
[(8,6,10)]
```

istenen özel 6-8-10 üçgenini bulan bir Haskell fonksiyonu.



## Chapter 3: Type System

























