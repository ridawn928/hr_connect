// @dart=3.6
// ignore_for_file: directives_ordering
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:riverpod_generator/builder.dart' as _i2;
import 'package:freezed/builder.dart' as _i3;
import 'package:json_serializable/builder.dart' as _i4;
import 'package:flutter_data/builders/adapter_builder.dart' as _i5;
import 'package:envied_generator/builder.dart' as _i6;
import 'package:drift_dev/integrations/build.dart' as _i7;
import 'package:source_gen/builder.dart' as _i8;
import 'package:mockito/src/builder.dart' as _i9;
import 'package:build_config/build_config.dart' as _i10;
import 'package:injectable_generator/builder.dart' as _i11;
import 'package:flutter_data/builders/data_library_builder.dart' as _i12;
import 'package:build_resolvers/builder.dart' as _i13;
import 'dart:isolate' as _i14;
import 'package:build_runner/build_runner.dart' as _i15;
import 'dart:io' as _i16;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'riverpod_generator:riverpod_generator',
    [_i2.riverpodBuilder],
    _i1.toDependentsOf(r'riverpod_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'freezed:freezed',
    [_i3.freezed],
    _i1.toDependentsOf(r'freezed'),
    hideOutput: false,
  ),
  _i1.apply(
    r'json_serializable:json_serializable',
    [_i4.jsonSerializable],
    _i1.toDependentsOf(r'json_serializable'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'flutter_data:data_adapter_builder',
    [_i5.adapterBuilder],
    _i1.toDependentsOf(r'flutter_data'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'envied_generator:envied',
    [_i6.enviedBuilder],
    _i1.toDependentsOf(r'envied_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'drift_dev:preparing_builder',
    [_i7.preparingBuilder],
    _i1.toNoneByDefault(),
    hideOutput: true,
    appliesBuilders: const [r'drift_dev:cleanup'],
  ),
  _i1.apply(
    r'drift_dev:drift_dev',
    [
      _i7.discover,
      _i7.analyzer,
      _i7.driftBuilder,
    ],
    _i1.toDependentsOf(r'drift_dev'),
    hideOutput: true,
    appliesBuilders: const [
      r'source_gen:combining_builder',
      r'drift_dev:preparing_builder',
    ],
  ),
  _i1.apply(
    r'source_gen:combining_builder',
    [_i8.combiningBuilder],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'source_gen:part_cleanup'],
  ),
  _i1.apply(
    r'mockito:mockBuilder',
    [_i9.buildMocks],
    _i1.toDependentsOf(r'mockito'),
    hideOutput: false,
    defaultGenerateFor: const _i10.InputSet(include: [r'test/**']),
  ),
  _i1.apply(
    r'injectable_generator:injectable_builder',
    [_i11.injectableBuilder],
    _i1.toDependentsOf(r'injectable_generator'),
    hideOutput: true,
  ),
  _i1.apply(
    r'injectable_generator:injectable_config_builder',
    [_i11.injectableConfigBuilder],
    _i1.toDependentsOf(r'injectable_generator'),
    hideOutput: false,
  ),
  _i1.apply(
    r'flutter_data:data_library_intermediate_builder',
    [_i12.dataExtensionIntermediateBuilder],
    _i1.toDependentsOf(r'flutter_data'),
    hideOutput: true,
  ),
  _i1.apply(
    r'flutter_data:data_library_builder',
    [_i12.dataExtensionBuilder],
    _i1.toDependentsOf(r'flutter_data'),
    hideOutput: false,
  ),
  _i1.apply(
    r'drift_dev:analyzer',
    [
      _i7.discover,
      _i7.analyzer,
    ],
    _i1.toNoneByDefault(),
    hideOutput: true,
    appliesBuilders: const [r'drift_dev:preparing_builder'],
  ),
  _i1.apply(
    r'drift_dev:not_shared',
    [_i7.driftBuilderNotShared],
    _i1.toNoneByDefault(),
    hideOutput: false,
  ),
  _i1.apply(
    r'drift_dev:modular',
    [_i7.modular],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'drift_dev:analyzer'],
  ),
  _i1.apply(
    r'build_resolvers:transitive_digests',
    [_i13.transitiveDigestsBuilder],
    _i1.toAllPackages(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [r'build_resolvers:transitive_digest_cleanup'],
  ),
  _i1.applyPostProcess(
    r'build_resolvers:transitive_digest_cleanup',
    _i13.transitiveDigestCleanup,
  ),
  _i1.applyPostProcess(
    r'source_gen:part_cleanup',
    _i8.partCleanup,
  ),
  _i1.applyPostProcess(
    r'drift_dev:cleanup',
    _i7.driftCleanup,
  ),
];
void main(
  List<String> args, [
  _i14.SendPort? sendPort,
]) async {
  var result = await _i15.run(
    args,
    _builders,
  );
  sendPort?.send(result);
  _i16.exitCode = result;
}
