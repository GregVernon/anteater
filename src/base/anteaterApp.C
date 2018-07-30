#include "anteaterApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<anteaterApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

anteaterApp::anteaterApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  anteaterApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  anteaterApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  anteaterApp::registerExecFlags(_factory);
}

anteaterApp::~anteaterApp() {}

void
anteaterApp::registerApps()
{
  registerApp(anteaterApp);
}

void
anteaterApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"anteaterApp"});
}

void
anteaterApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"anteaterApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
anteaterApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
anteaterApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
anteaterApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
anteaterApp__registerApps()
{
  anteaterApp::registerApps();
}

extern "C" void
anteaterApp__registerObjects(Factory & factory)
{
  anteaterApp::registerObjects(factory);
}

extern "C" void
anteaterApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  anteaterApp::associateSyntax(syntax, action_factory);
}

extern "C" void
anteaterApp__registerExecFlags(Factory & factory)
{
  anteaterApp::registerExecFlags(factory);
}
