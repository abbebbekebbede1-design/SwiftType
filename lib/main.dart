import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const bg = Color(0xFF080B19);
const panel = Color(0xFF171D33);
const blue = Color(0xFF087BFF);
const purple = Color(0xFF753BFF);
const lavender = Color(0xFFB9C7FF);
const channel = MethodChannel('com.swifttype/ime');

void main() => runApp(const SwiftTypeApp());

class SwiftTypeApp extends StatelessWidget {
  const SwiftTypeApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SwiftType', debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: bg, colorScheme: const ColorScheme.dark(
        primary: blue, secondary: purple, surface: panel),
      textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
          ),
    home: const MainShell(),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int tab = 0;
  final pages = const [HomePage(), ThemesPage(), FontsPage(), StudioPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: pages[tab]),
    bottomNavigationBar: NavigationBar(
      backgroundColor: const Color(0xFF0B1022), indicatorColor: blue.withOpacity(.18),
      selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.palette_outlined), label: 'Themes'),
        NavigationDestination(icon: Icon(Icons.text_fields), label: 'Fonts'),
        NavigationDestination(icon: Icon(Icons.auto_awesome), label: 'Studio'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Row(children: [const Icon(Icons.waves, color: purple, size: 34), const SizedBox(width: 10),
      const Expanded(child: Text('SwiftType', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      IconButton(onPressed: () => openPage(context, const SettingsPage()), icon: const Icon(Icons.settings_outlined))]),
    const SizedBox(height: 5),
    const Text('Type Smarter. Express Yourself.', style: TextStyle(color: lavender)),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [blue, purple])),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('PERSONALIZE YOUR EVERYDAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10), const Text('Your Keyboard,\nYour Style', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14), FilledButton.tonal(onPressed: () => openPage(context, const ThemesPage()),
          child: const Text('Explore Themes  →')),
      ])),
    const SizedBox(height: 22), const Text('Make it yours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2,
      mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.55, children: [
        FeatureTile(icon: Icons.palette_outlined, title: 'Keyboard Themes', subtitle: 'Find your signature look', onTap: () => openPage(context, const ThemesPage())),
        FeatureTile(icon: Icons.language, title: 'Languages', subtitle: 'English + Amharic', onTap: () => openPage(context, const KeyboardPage())),
        FeatureTile(icon: Icons.text_fields, title: 'Amharic Fonts', subtitle: 'Made for your words', onTap: () => openPage(context, const FontsPage())),
        FeatureTile(icon: Icons.font_download_outlined, title: 'English Stylish Fonts', subtitle: 'A fresh take on type', onTap: () => openPage(context, const StudioPage())),
        FeatureTile(icon: Icons.auto_awesome, title: 'Stylish Text Studio', subtitle: 'Create. Copy. Stand out.', onTap: () => openPage(context, const StudioPage())),
        FeatureTile(icon: Icons.emoji_emotions_outlined, title: 'Emoji & GIFs', subtitle: 'Say a little more', onTap: () => openPage(context, const EmojiPage())),
      ]),
    const SizedBox(height: 12),
    FeatureTile(icon: Icons.keyboard_alt_outlined, title: 'Keyboard playground', subtitle: 'Preview English and Amharic layouts', onTap: () => openPage(context, const KeyboardPage())),
  ]);
}

void openPage(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

class FeatureTile extends StatelessWidget {
  final IconData icon; final String title, subtitle; final VoidCallback onTap;
  const FeatureTile({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16),
    child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: lavender), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white60)),
      ])));
}

class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});
  final themes = const ['Neon Blue','Purple Galaxy','Forest Green','Pink Cherry Blossom','Dark Marble','Sunset Gradient'];
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Theme Store')), body: GridView.builder(
    padding: const EdgeInsets.all(16), itemCount: themes.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, childAspectRatio: .9, crossAxisSpacing: 12, mainAxisSpacing: 12),
    itemBuilder: (_, i) => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(colors: i == 1 ? [purple, panel] : [blue.withOpacity(.7), panel])),
      padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end,
        children: [const Icon(Icons.keyboard_alt, size: 40), const SizedBox(height: 8), Text(themes[i], style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8), OutlinedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${themes[i]} preview selected (theme engine pending).'))), child: const Text('Preview'))]))));
}

class FontsPage extends StatelessWidget {
  const FontsPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Font Library')), body: ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Amharic fonts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ...['Noto Sans Ethiopic','Noto Serif Ethiopic','Abyssinica SIL','Menbere','Semayawi','Benaiah'].map((f) => FontTile(name: f, sample: 'አማርኛ ፊደል')),
    const SizedBox(height: 20), const Text('English fonts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ...['Inter','Roboto','Poppins','Montserrat','Playfair Display','JetBrains Mono'].map((f) => FontTile(name: f, sample: 'SwiftType typography')),
  ]));
}
class FontTile extends StatelessWidget {
  final String name, sample; const FontTile({super.key, required this.name, required this.sample});
  @override Widget build(BuildContext context) => Card(child: ListTile(title: Text(name), subtitle: Text(sample, style: const TextStyle(fontSize: 20)), trailing: const Icon(Icons.chevron_right)));
}

class StudioPage extends StatefulWidget {
  const StudioPage({super.key});
  @override State<StudioPage> createState() => _StudioPageState();
}
class _StudioPageState extends State<StudioPage> {
  final controller = TextEditingController(); String mode = 'Live conversion'; String style = 'Sans Bold';
  String convert(String s) {
    const normal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const bold = '𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇';
    const serif = '𝐀𝐁𝐂𝐃𝐄𝐅𝐆𝐇𝐈𝐉𝐊𝐋𝐌𝐍𝐎𝐏𝐐𝐑𝐒𝐓𝐔𝐕𝐖𝐗𝐘𝐙𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳';
    final target = style == 'Serif Bold' ? serif : bold;
    return s.split('').map((c) { final i = normal.indexOf(c); return i < 0 ? c : target[i]; }).join();
  }
  @override Widget build(BuildContext context) {
    final output = convert(controller.text);
    return Scaffold(appBar: AppBar(title: const Text('Stylish Text Studio')), body: ListView(padding: const EdgeInsets.all(16), children: [
      SegmentedButton<String>(segments: const [ButtonSegment(value:'Live conversion',label:Text('Live')),ButtonSegment(value:'Convert after typing',label:Text('After typing'))],
        selected: {mode}, onSelectionChanged: (v) => setState(() => mode = v.first)),
      const SizedBox(height: 16), TextField(controller: controller, maxLines: 5, onChanged: (_) => setState((){}),
        decoration: const InputDecoration(filled:true, fillColor:panel, hintText:'Make every word yours.', border:OutlineInputBorder())),
      const SizedBox(height: 12), Wrap(spacing:8, children: ['Sans Bold','Serif Bold'].map((s) => ChoiceChip(label:Text(s),selected:style==s,onSelected:(_)=>setState(()=>style=s))).toList()),
      const SizedBox(height: 16), const Text('CONVERTED PREVIEW', style: TextStyle(color:lavender,fontSize:11)),
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(16)),
        child: Text(mode == 'Live conversion' ? output : (controller.text.isEmpty ? 'Your converted text appears here.' : 'Tap Convert to create your styled text.'),
          style:const TextStyle(fontSize:22))),
      if (mode == 'Convert after typing') FilledButton(onPressed:()=>setState((){}),child:const Text('Convert entire text')),
      FilledButton.icon(onPressed:()=>Clipboard.setData(ClipboardData(text:output)),icon:const Icon(Icons.copy),label:const Text('Copy text')),
      const Text('Amharic text keeps its original characters. Use real font rendering or image export for visual preservation.',style:TextStyle(color:Colors.white54,fontSize:12)),
    ]));
  }
}

class KeyboardPage extends StatefulWidget { const KeyboardPage({super.key}); @override State<KeyboardPage> createState()=>_KeyboardPageState(); }
class _KeyboardPageState extends State<KeyboardPage> {
  String layout = 'Layout 2';
  Future<void> save() async { try { await channel.invokeMethod('setAmharicLayout', {'layout':layout}); } on PlatformException {} }
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Keyboard playground')),body:ListView(padding:const EdgeInsets.all(16),children:[
    SegmentedButton<String>(segments:const [ButtonSegment(value:'Layout 1',label:Text('Full grid')),ButtonSegment(value:'Layout 2',label:Text('Fidel variations'))],
      selected:{layout},onSelectionChanged:(v){setState(()=>layout=v.first);save();}),
    const SizedBox(height:16), const Text('Amharic keyboard preview',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
    const Text('The selected layout is saved for the native Android keyboard.'),
    const SizedBox(height:16), Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(16)),
      child: Column(children:[
        for(final row in (layout=='Layout 2' ? [['ሀ','ለ','ሐ','መ','ሠ','ረ','ሰ','ሸ','ቀ','በ'],['ነ','ተ','ቸ','ኀ','ከ','ኸ','ወ','ዐ','ዘ','ዠ'],['አ','ኡ','ኢ','ኣ','ኤ','እ','ኦ','ዐ']] : [['ሀ','ለ','ሐ','መ','ሠ','ረ','ሰ','ሸ','ቀ','በ'],['ቡ','ቢ','ባ','ቤ','ብ','ቦ','ነ','ኑ','ኒ','ና'],['አ','ኡ','ኢ','ኣ','ኤ','እ','ኦ','ዐ','ዘ','ዠ']]))
          Padding(padding:const EdgeInsets.symmetric(vertical:3),child:Row(children:row.map((c)=>Expanded(child:Container(margin:const EdgeInsets.all(2),padding:const EdgeInsets.symmetric(vertical:12),decoration:BoxDecoration(color:const Color(0xFF292D39),borderRadius:BorderRadius.circular(7)),child:Text(c,textAlign:TextAlign.center,style:const TextStyle(fontSize:19))))).toList())),
      ])),
    const SizedBox(height:16), FilledButton(onPressed:()=>openAndroidSettings(context),child:const Text('Enable SwiftType keyboard in Android settings')),
  ]));
}
Future<void> openAndroidSettings(BuildContext context) async { try { await channel.invokeMethod('openImeSettings'); } catch (_) { if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Open Android Settings → System → Keyboard → On-screen keyboard.'))); } }

class SettingsPage extends StatefulWidget { const SettingsPage({super.key}); @override State<SettingsPage> createState()=>_SettingsPageState(); }
class _SettingsPageState extends State<SettingsPage> {
 bool suggestions=true, autocorrect=true, vibration=false, sound=false;
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Keyboard Settings')),body:ListView(padding:const EdgeInsets.all(16),children:[
  const Text('Languages',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
  const ListTile(leading:Icon(Icons.language),title:Text('English (US) + Amharic'),subtitle:Text('No additional languages enabled')),
  const Divider(), SwitchListTile(value:suggestions,onChanged:(v)=>setState(()=>suggestions=v),title:const Text('Word suggestions')),
  SwitchListTile(value:autocorrect,onChanged:(v)=>setState(()=>autocorrect=v),title:const Text('Autocorrect')),
  SwitchListTile(value:vibration,onChanged:(v)=>setState(()=>vibration=v),title:const Text('Key vibration')),
  SwitchListTile(value:sound,onChanged:(v)=>setState(()=>sound=v),title:const Text('Key sound')),
  const ListTile(leading:Icon(Icons.privacy_tip_outlined),title:Text('Privacy'),subtitle:Text('Keyboard input privacy information')),
  const ListTile(leading:Icon(Icons.info_outline),title:Text('About SwiftType'),subtitle:Text('Version 0.1.0 · Development build')),
 ]));
}
class EmojiPage extends StatelessWidget { const EmojiPage({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Emoji & symbols')),body:const Center(child:Text('Emoji, stickers and GIF integration is planned for the next implementation stage.'))); }
