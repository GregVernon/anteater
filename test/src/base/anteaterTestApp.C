//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "anteaterTestApp.h"
#include "anteaterApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<anteaterTestApp>()
{
  InputParameters params = validParams<anteaterApp>();
  return params;
}

anteaterTestApp::anteaterTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  anteaterApp::registerObjectDepends(_factory);
  anteaterApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  anteaterApp::associateSyntaxDepends(_syntax, _action_factory);
  anteaterApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  anteaterApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    anteaterTestApp::registerObjects(_factory);
    anteaterTestApp::associateSyntax(_syntax, _action_factory);
    anteaterTestApp::registerExecFlags(_factory);
  }
}

anteaterTestApp::~anteaterTestApp() {}

void
anteaterTestApp::registerApps()
{
  registerApp(anteaterApp);
  registerApp(anteaterTestApp);
}

void
anteaterTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
anteaterTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
anteaterTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
anteaterTestApp__registerApps()
{
  anteaterTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
anteaterTestApp__registerObjects(Factory & factory)
{
  anteaterTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
anteaterTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  anteaterTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
anteaterTestApp__registerExecFlags(Factory & factory)
{
  anteaterTestApp::registerExecFlags(factory);
}
