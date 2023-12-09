// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'item_detail.dart';
import 'item_edit.dart';
import 'current_session.dart';

GestureDetector item_listing(
    title, price, name, imgURL, desc, id, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (name != CurrentSession.getCurrentName()) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemDetail(
                    title: title,
                    price: price,
                    name: name,
                    imgURL: imgURL,
                    desc: desc,
                    id: id,
                  )),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemEdit(
                    title: title,
                    price: price,
                    name: name,
                    imgURL: imgURL,
                    desc: desc,
                    id: id,
                  )),
        );
      }
    },
    child: Container(
      //width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        //color: Colors.indigo,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x3600000F),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      imgURL,
                      width: 100,
                      height: 113,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 0, 0),
                    child: Text(
                      title,
                      //style: AppTheme.of(context).bodyText1,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 10, 0),
                    child: Text(
                      '\$$price',
                      //style: AppTheme.of(context).bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                      //style: AppTheme.of(context).bodyText2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
