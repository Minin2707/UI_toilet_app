import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../data/models/user_message_request.dart';
import '../../data/repositories/user_message_repository.dart';
import '../../data/models/user_message_type.dart';
import '../../../../l10n/app_localizations.dart';


class UserMessageScreen extends StatefulWidget {
  const UserMessageScreen({
    super.key,
  });

  @override
  State<UserMessageScreen> createState() =>
      _UserMessageScreenState();
}

class _UserMessageScreenState
    extends State<UserMessageScreen> {

  final TextEditingController
      _messageController =
          TextEditingController();

  final UserMessageRepository
      _repository =
          UserMessageRepository();

  UserMessageType _selectedType =
      UserMessageType.suggestion;

  int _messageLength = 0;

  Future<void> _sendMessage() async {

    final message =
        _messageController.text.trim();

    final l10n =
        AppLocalizations.of(context)!;

    if (message.isEmpty) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

         SnackBar(
          content: Text(
            l10n.messageCannotBeEmpty,
          ),
        ),
      );

      return;
    }

    try {

      final request =
          UserMessageRequest(

        type: _selectedType,

        message: message,
      );

      await _repository.send(
        request,
      );

      if (!mounted) {
        return;
      }

      _messageController.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(
          content: Text(
            l10n.feedbackSent,
          ),
        ),
      );

      context.pop();

    } catch (_) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(
          content: Text(
            l10n.feedbackFailed,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {

    _messageController.dispose();

    super.dispose();
  }

  String _typeLabel(
    UserMessageType type,
    AppLocalizations l10n,
  ) {

    switch (type) {

      case UserMessageType.suggestion:
        return l10n.suggestion;

      case UserMessageType.complaint:
        return l10n.complaint;

      case UserMessageType.bug:
        return l10n.bug;

      case UserMessageType.other:
        return l10n.other;
    }
  }

  @override
  Widget build(BuildContext context) {

    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(

      backgroundColor:
          const Color(0xFF07111A),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFF07111A),

        elevation: 0,

        title:  Text(
           l10n.feedbackTitle,
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(
              height: 16,
            ),

            Text(

              l10n.messageType,

              style: TextStyle(

                color: Colors.white,

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              decoration: BoxDecoration(

                color:
                    Colors.white.withOpacity(
                  0.08,
                ),

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),

              child:
                  DropdownButtonHideUnderline(

                child:
                    DropdownButton<UserMessageType>(

                  value:
                      _selectedType,

                  dropdownColor:
                      const Color(
                    0xFF0B3550,
                  ),

                  isExpanded: true,

                  style:
                      const TextStyle(
                    color: Colors.white,
                  ),

                  items:
                      UserMessageType.values.map(
                    (type) {

                      return DropdownMenuItem(

                        value: type,

                        child: Text(
                          _typeLabel(
                            type,
                            l10n,
                          ),
                        ),
                      );
                    },
                  ).toList(),

                  onChanged: (value) {

                    if (value == null) {
                      return;
                    }

                    setState(() {

                      _selectedType =
                          value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Text(

              l10n.message,

              style: TextStyle(

                color: Colors.white,

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Expanded(

              child: TextField(

                controller:
                    _messageController,

                inputFormatters: [

                  LengthLimitingTextInputFormatter(
                    2000,
                  ),
                ],

                onChanged: (value) {

                  setState(() {

                    _messageLength =
                        value.length;
                  });
                },

                maxLines: null,

                expands: true,

                style:
                    const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                    InputDecoration(

                  hintText:
                      l10n.messageHint,

                  hintStyle:
                      TextStyle(

                    color:
                        Colors.white
                            .withOpacity(
                      0.5,
                    ),
                  ),

                  filled: true,

                  fillColor:
                      Colors.white
                          .withOpacity(
                    0.08,
                  ),

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Align(

              alignment:
                  Alignment.centerRight,

              child: Text(

                '$_messageLength / 2000',

                style: TextStyle(

                  color:
                      Colors.white.withOpacity(
                    0.6,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(

              width:
                  double.infinity,

              height: 56,

              child: ElevatedButton(
                       onPressed: _sendMessage,
                       child:  Text(
                         l10n.send,
                       ),
                     ),
            ),
          ],
        ),
      ),
    );
  }
}