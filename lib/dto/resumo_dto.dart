class ResumoDTO{
  ResumoDTO ({
    required this.mes,
    required this.saldoEmConta,
    required this.totalDespesasMes,
    required this.totalReceitasMes
});

  final String mes;
  final double saldoEmConta;
  final double totalDespesasMes;
  final double totalReceitasMes;
}