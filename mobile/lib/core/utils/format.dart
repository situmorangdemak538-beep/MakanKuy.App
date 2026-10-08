const _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const _daysShort = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
const _months = [  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];
const _monthsLong = [  
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

/// 35000 -> "Rp 35.000"
String rupiah(int v) { 
  final s = v.toString();  
  final b = StringBuffer();  
  for (var i = 0; i < s.length; i++) {    
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');    
    b.write(s[i]); 
  }  
  return 'Rp $b';
}

String rb(int v) => 'Rp${v ~/ 1000}rb';
String rk(int v) => 'Rp ${v ~/ 1000}k'; 
String dayName(DateTime d) => _days[d.weekday - 1];
String dayShort(DateTime d) => _daysShort[d.weekday - 1];
String monthShort(DateTime d) => _months[d.month - 1];
String monthLong(DateTime d) => _monthsLong[d.month - 1];
String dateLabel(DateTime d) =>    '${dayName(d)}, ${d.day} ${monthShort(d)} ${d.year}'; 

bool isSameDay(DateTime a, DateTime b) =>    
  a.year == b.year && a.month == b.month && a.day == b.day; 

String relDay(DateTime d) {  
  final now = DateTime.now();  
  if (isSameDay(d, now)) return 'Hari Ini';  
  if (isSameDay(d, now.add(const Duration(days: 1)))) return 'Besok';  
  return '${dayName(d)}, ${d.day} ${monthShort(d)}';
}