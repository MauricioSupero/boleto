import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/insert_boleto/insert_boleto_controller.dart';

import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  final String? barcode;
  const InsertBoletoPage({
    Key? key,
    this.barcode,
  }) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();
  final moneyInputTextcontroller = MoneyMaskedTextController(
    leftSymbol: "R\$",
    decimalSeparator: ",",
  );

  final dueDateInputTextController = MaskedTextController(mask: "00/00/0000");

  final barcodeTextInputController = TextEditingController();

  @override
  void initState() {
    if (widget.barcode != null) {
      barcodeTextInputController.text = widget.barcode!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(
          color: AppColors.input,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 93),
                child: Text(
                  "Preencha os dados do Boleto",
                  style: AppTextStyles.titleBoldHeading,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      InputTextWidget(
                        validator: controller.validateName,
                        onChanged: (value) {
                          controller.onChange(name: value);
                        },
                        label: "Nome do Boleto",
                        icon: Icons.description_outlined,
                      ),
                      InputTextWidget(
                        validator: controller.validateVencimento,
                        controller: dueDateInputTextController,
                        onChanged: (value) {
                          controller.onChange(dueDate: value);
                        },
                        label: "Vencimento",
                        icon: FontAwesomeIcons.timesCircle,
                      ),
                      InputTextWidget(
                        validator: (_) => controller.validateValor(
                            moneyInputTextcontroller.numberValue),
                        controller: moneyInputTextcontroller,
                        onChanged: (value) {
                          controller.onChange(
                              value: moneyInputTextcontroller.numberValue);
                        },
                        label: "Valor",
                        icon: FontAwesomeIcons.wallet,
                      ),
                      InputTextWidget(
                        validator: controller.validateCodigo,
                        controller: barcodeTextInputController,
                        onChanged: (value) {
                          controller.onChange(barcode: value);
                        },
                        label: "Código",
                        icon: FontAwesomeIcons.barcode,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
        enableSecondaryColor: true,
        primaryLabel: "Cancelar",
        primaryOnPressed: () {
          Navigator.pop(context);
        },
        secondaryLabel: "Cadastrar",
        secondaryOnPressed: () async {
          await controller.cadastrarBoleto();
          Navigator.pop(context);
        },
      ),
    );
  }
}
