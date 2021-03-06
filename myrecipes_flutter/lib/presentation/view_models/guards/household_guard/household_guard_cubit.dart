import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/group_repository/group_repository.dart';

part 'household_guard_state.dart';

class HouseholdGuardCubit extends Cubit<HouseholdGuardState> {
  GroupRepository _groupRepository;

  HouseholdGuardCubit(this._groupRepository) : super(HouseholdGuardInitial());

  Future<void> checkHouseholdState() async {
    try {
      var group = await _groupRepository.getGroup();
      emit(HouseholdGuardInGroup());
      log("Household fetched successfully");
    } catch (e) {
      log(e.toString());
      emit(HouseholdGuardCreateOrJoin(errorMessage: e.toString()));
    }
  }

  Future<void> createHousehold(String name) async {
    try {
      await _groupRepository.create(name);
      checkHouseholdState();
    } catch (e) {
      log(e.toString());
      emit(HouseholdGuardCreateOrJoin(
          errorMessage: "Could not create household: " + e.toString()));
    }
  }

  Future<void> joinWithCode(String inviteCode) async {
    try {
      await _groupRepository.joinWithInviteCode(inviteCode);
      checkHouseholdState();
    } catch (e) {
      log(e.toString());
      emit(HouseholdGuardCreateOrJoin(errorMessage: e.toString()));
    }
  }
}
