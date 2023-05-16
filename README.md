--------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PROYEK AKHIR SSF - KELOMPOK A5
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Bintang Marsyuma Rakhasunu - 2106731415 <br>
Brian Yudha Sandi - 2106637082 <br>
Michael Gunawan - 2106731195 <br>
Muhammad Salman Sadad - 2106731371 <br>

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Introduction to the problem and the solution
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

Taman adalah salah satu tempat yang paling menenangkan dan menyegarkan bagi banyak orang, dan karena taman merupakan tempat terbuka, taman memerlukan penerangan. Namun, yang menjadi masalah disini adalah, kurang efisiennya penggunaan daya pada lampu yang digunakan di taman, dan kurangnya otomatisasi ketika terjadi perubahan dari siang ke malam. Oleh karena itu, kami membawa solusi yaitu kami merancang sistem otomatisasi yang dapat mengatur penggunaan lampu taman secara efisien dan hemat energi. 

Solusi yang kami bawa, secara garis besar, kami ingin agar lampu taman bisa menyala secara otomatis mengikuti kondisi terang-gelap yang sedang ada di sekitar lampu taman tersebut

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Hardware design and implementation details
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Komponen yang dibutuhkan:
Arduino Uno - 1 buah
Breadboard - 1 buah
Light Dependent Resistor - 1 buah
LED - 9 buah
MAX7219 - 1 buah
Kabel jumper
Baterai 9V - 1 buah

Rangkaian kami menggunakan breadboard, dan Arduino Uno sebagai otak dari rangkaian kami. Kami menggunakan satu buah LDR / Light Dependant Resistor untuk mengukur intensitas cahaya. Setelah itu, data akan diproses, dan LED akan bekerja sebagai output. Jika intensitas cahaya yang terbaca tinggi maka itu menandakan situasi sedang siang sehingga led tidak akan menyala namun jika intensitas yang terbaca rendah maka hal itu menandakan kondisi sedang malam sehingga led akan perlahan menyala dengan menyesuaikan kondisi data yang dia terima. Kami juga memakai satu buah button yang akan bertindak sebagai force shutdown alias lampu akan mati saat tombol ditekan dengan menggunakan prinsip interrupt. Sebagai tambahan, terdapat juga max7219 yang akan mengolah sinyal analog untuk menampilkan string “SIANG” dan “MALAM” dengan memanfaatkan modul seven-segment

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Software implementation details
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Kode akan membuat LDR melakukan deteksi terus menerus dalam routine readADC. Kemudian, jika intensitas cahaya yang diterima memiliki nilai tertentu, nilai tersebut akan diproses dalam percabangan instruksi dengan lima kasus. Kasus ke-1 adalah jika cahaya rendah, maka semua lampu menyala. Kemudian kasus ke-2 sampai ke-5 akan mendeteksi intensitas cahaya dan jika semakin banyak cahaya, maka akan semakin sedikit lampu yang menyala. Penentuan instruksi berdasarkan kasus tersebut dilakukan dengan melakukan compare dari hasil konversi dari data sensor dengan nilai tertentu.

Selain itu, terdapat fitur penunjukan status dari lampu yang akan ditampilkan oleh komponen MAX7219 yang diintegrasikan dengan 2 seven-segment LED. Untuk melakukan hal tersebut, kami menerapkan komunikasi serial yang dikonfigurasi dalam arduino.
Komunikasi serial diproses menggunakan komunikasi SPI dengan kode yang kita buat, yang berguna untuk menyalakan modul MAX7219 yang menunjukan tulisan “MALAM” pada kasus ke-1, ke-2 dan menunjukan tulisan “SIANG” pada kasus ke-3, ke-4, dan ke-5.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Test results and performance evaluation
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Kami melakukan ujicoba dengan menggunakan bantuan senter. Tujuannya, adalah kami ingin mensimulasikan keadaan saat siang hari. Sedikit perlu ada perubahan dari segi kode, kami melakukan penyesuaian, dan juga pada sensor LDR juga diperlukan adanya penyesuaian. Penyesuaian tersebut diperlukan agar output yang dihasilkan sesuai dengan rancangan kami, dimana ketika intensitas cahaya berada di kisaran 50% sampai 100%, akan menampilkan “siang”, dan lampu LED yang merepresentasikan lampu taman akan mati. Untuk kondisi malam, rangkaian kami telah bekerja dengan baik, dibuktikan ketika tidak ada lampu senter atau sensor berada dalam kondisi gelap atau redup, serial monitor pada rangkaian kami akan menampilkan “malam”.

Ketika kami memberikan senter yang menyala kepada LDR-nya maka lampu led akan mati dan pada MAX7219 terdapat string yang bertuliskan siang dan begitu pula sebaliknya, ketika tidak ada cahaya dari senter yang didekatkan kepada LDR maka akan dianggap sebagai kondisi malam yang mengindikasikan lampu led mulai menyala dan tampil string yang menuliskan malam

Kami menyadari penurunan kualitas dari LDR yang seolah-olah semakin kurang sensitif ketika proses testing diulang berkali-kali, hal ini berdampak pada ldr yang sudah diterangi dengan senter namun tidak dapat bereaksi layaknya sedang dalam kondisi siang atau dengan kata lain terdapat permasalahan kestabilan dalam segi sensor

Inkonsistensi hasil antara skematik di aplikasi proteus dan rangkaian fisik juga menjadi salah satu hambatan kami atau dengan kata lain meskipun komponen dan kode yang digunakan telah sama, hasil keluaran yang didapatkan kadang kali tidak konsisten antara proteus dengan rangkaian fisiknya. Kami menduga kecakapan komponen yang digunakan menjadi penyebab di balik timbulnya ketidakkonsistenan masalah ini 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Conclusion and future work
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Kesimpulan dalam proyek akhir kami adalah, rangkaian kami bisa berjalan dengan baik, namun dengan catatan, terdapat inkonsistensi dari sensitifitas LDR dan terdapat juga perbedaan antara rangkaian fisik dengan rangkaian skematik dalam proteus. Untuk proyek berikutnya, kami ingin menggunakan hardware yang lebih akurat, sehingga menghasilkan produk yang lebih baik dari yang kami rancang sekarang




