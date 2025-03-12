import 'package:flutter/material.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<int> _bookmarks = [];
  bool _isBookmarkMenuOpen = false;

  
  
final List<String> _quranPages = List.generate(
  604, 
  (index) => 'quran_pages/${index.toString().padLeft(3, '0')}.png',
);

  
  final Color mainColor = Color.fromARGB(255, 0, 35, 0);
  final Color accentColor = Color.fromARGB(255, 255, 255, 255);
  
  final Color buttonColor = Colors.grey.withOpacity(0.7);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleBookmark(int pageIndex) {
    setState(() {
      if (_bookmarks.contains(pageIndex)) {
        _bookmarks.remove(pageIndex);
      } else {
        _bookmarks.add(pageIndex);
      }
    });
  }

  void _jumpToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isBookmarkMenuOpen = false;
    });
  }

  void _nextPage() {
    if (_currentPage < _quranPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Quran',
          style: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              setState(() {
                _isBookmarkMenuOpen = !_isBookmarkMenuOpen;
              });
            },
          ),
        ],
      ),
      body: Container(
        color: mainColor,
        child: Stack(
          children: [
            
            GestureDetector(
              
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  
                  _nextPage();
                } else if (details.primaryVelocity! < 0) {
                  
                  _previousPage();
                }
              },
              child: PageView.builder(
                controller: _pageController,
                reverse: true, 
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _quranPages.length,
                itemBuilder: (context, index) {
                  return _buildQuranPage(index);
                },
              ),
            ),
            
            
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double page = _pageController.hasClients 
                    ? (_pageController.page ?? 0) 
                    : 0;
                double pageOffset = page - page.floor();
                
                return Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,  
                          end: Alignment.centerRight,   
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.3 * pageOffset),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      GestureDetector(
                        onTap: _nextPage,  
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      
                      
                      Row(
                        children: [
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Page ${_currentPage + 1} of ${_quranPages.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Oxygen',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          
                          
                          GestureDetector(
                            onTap: () => _toggleBookmark(_currentPage),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _bookmarks.contains(_currentPage) ? buttonColor : buttonColor.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Icon(
                                _bookmarks.contains(_currentPage) ? Icons.bookmark : Icons.bookmark_border,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      
                      GestureDetector(
                        onTap: _previousPage,  
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            
            if (_isBookmarkMenuOpen)
              Positioned(
                top: 0,
                right: 0,
                width: 200,
                child: Container(
                  margin: EdgeInsets.only(top: 60, right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bookmarks',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isBookmarkMenuOpen = false;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const Divider(height: 16, thickness: 1, color: Colors.white38),
                      _bookmarks.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'No bookmarks yet',
                                style: TextStyle(
                                  fontFamily: 'Oxygen',
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white70,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: _bookmarks.length,
                                itemBuilder: (context, index) {
                                  final pageNumber = _bookmarks[index] + 1;
                                  return ListTile(
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      horizontal: 0,
                                      vertical: -3,
                                    ),
                                    leading: const Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text(
                                      '$pageNumber',
                                      style: const TextStyle(
                                        fontFamily: 'Oxygen',
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () => _jumpToPage(_bookmarks[index]),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () =>
                                          _toggleBookmark(_bookmarks[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),

            
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranPage(int index) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          
          Image.asset(
            _quranPages[index],
            fit: BoxFit.contain,
            width: double.infinity,
            
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFF8F3E6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                        style: TextStyle(
                          fontFamily: 'ScheherazadeNew',
                          fontSize: 28,
                          color: Color(0xFF3C3C3C),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Page ${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 18,
                          color: Color(0xFF3C3C3C),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 35, 0),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Add Quran page images to\nassets/quran_pages/page_X.png',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Oxygen',
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 35, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(40, 0, 35, 0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          
          Positioned(
            left: 0,  
            top: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(40, 0, 35, 0),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}