import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/telas/tela_historico.dart';
import 'package:orcamento_pedreiro/telas/tela_orcamento.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    // Inicializa o PageController
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  void dispose() {
    // Libera o PageController quando o widget é removido da árvore
    pc.dispose();
    super.dispose();
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          TelaOrcamento(),
          TelaHistorico(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(
              backgroundColor: Color(0xFF424242), // Cor de fundo

              icon: Icon(
                Icons.add_business,
              ),
              label: "Orçamento"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outlined,
              ),
              label: "Histórico"),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: Duration(microseconds: 400),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
