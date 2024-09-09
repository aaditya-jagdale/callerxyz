import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:callerxyz/modules/crm/models/client_model.dart';

final clientsProvider =
    StateNotifierProvider<ClientsNotifier, List<ClientModel>>((ref) {
  return ClientsNotifier();
});

class ClientsNotifier extends StateNotifier<List<ClientModel>> {
  ClientsNotifier() : super(<ClientModel>[]);

  void addClient(ClientModel client) {
    state = [client, ...state];
  }

  void sortByName() {
    state = List.from(state)..sort((a, b) => a.name.compareTo(b.name));
  }

  void sortByCreatedAt() {
    state = List.from(state)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void removeClient(int clientid) {
    state = state.where((c) => c.id != clientid).toList();
  }

  void updateClient(ClientModel updatedClient) {
    state = state
        .map((client) => client.id == updatedClient.id ? updatedClient : client)
        .toList();
  }

  void setClients(List<ClientModel> clients) {
    state = clients;
  }

  void clearClients() {
    state = [];
  }
}
